import 'dart:convert';

enum MathOperation { multiplication, division }

MathOperation operationFromCode(String code) {
  switch (code) {
    case 'mul':
      return MathOperation.multiplication;
    case 'div':
      return MathOperation.division;
    default:
      throw ArgumentError('Unknown operation code: $code');
  }
}

String operationToCode(MathOperation op) {
  switch (op) {
    case MathOperation.multiplication:
      return 'mul';
    case MathOperation.division:
      return 'div';
  }
}

class MathFact {
  final String id;
  final MathOperation operation;
  final int a;
  final int b;
  final String expression;
  final int result;

  const MathFact({
    required this.id,
    required this.operation,
    required this.a,
    required this.b,
    required this.expression,
    required this.result,
  });

  factory MathFact.fromJson(Map<String, dynamic> json) => MathFact(
    id: json['id'] as String,
    operation: operationFromCode(json['op'] as String),
    a: json['a'] as int,
    b: json['b'] as int,
    expression: json['expr'] as String,
    result: json['result'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'op': operationToCode(operation),
    'a': a,
    'b': b,
    'expr': expression,
    'result': result,
  };
}

class TableFacts {
  final int table;
  final List<MathFact> multiplication;
  final List<MathFact> division;

  const TableFacts({
    required this.table,
    required this.multiplication,
    required this.division,
  });

  factory TableFacts.fromJson(int table, Map<String, dynamic> json) =>
      TableFacts(
        table: table,
        multiplication: (json['multiplication'] as List<dynamic>)
            .map((e) => MathFact.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        division: (json['division'] as List<dynamic>)
            .map((e) => MathFact.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
      );
}

class RangeMeta {
  final int min;
  final int max;
  const RangeMeta({required this.min, required this.max});

  factory RangeMeta.fromJson(Map<String, dynamic> json) =>
      RangeMeta(min: json['min'] as int, max: json['max'] as int);
}

class Metadata {
  final RangeMeta range;
  final String locale;
  final String version;
  const Metadata({
    required this.range,
    required this.locale,
    required this.version,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    range: RangeMeta.fromJson(json['range'] as Map<String, dynamic>),
    locale: json['locale'] as String,
    version: json['version'] as String,
  );
}

class MathFactsData {
  final Map<int, TableFacts> tables;
  final Metadata metadata;
  const MathFactsData({required this.tables, required this.metadata});

  factory MathFactsData.fromJson(Map<String, dynamic> json) {
    final tablesJson = json['tables'] as Map<String, dynamic>;
    final tables = <int, TableFacts>{};
    for (final entry in tablesJson.entries) {
      final key = int.parse(entry.key);
      tables[key] = TableFacts.fromJson(
        key,
        entry.value as Map<String, dynamic>,
      );
    }
    return MathFactsData(
      tables: tables,
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }

  static MathFactsData parse(String source) =>
      MathFactsData.fromJson(json.decode(source) as Map<String, dynamic>);
}
