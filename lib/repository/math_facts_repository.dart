import 'package:flutter/services.dart' show rootBundle;
import '../models/math_facts.dart';

class MathFactsRepository {
  final String assetPath;
  RangeMeta? rangeMeta;

  MathFactsRepository({this.assetPath = 'assets/math_facts.json'});

  Future<MathFactsData> _loadData() async {
    final raw = await rootBundle.loadString(assetPath);
    return MathFactsData.parse(raw);
  }

  Future<List<TableFacts>> loadTables() async {
    final data = await _loadData();
    List<TableFacts> tables = data.tables.values.toList(growable: false);
    return tables;
  }

  Future<List<MathFact>> loadExercises() async {
    final data = await _loadData();
    rangeMeta ??= data.metadata.range;
    List<MathFact> pool = [];
    pool.clear();
    for (final table in data.tables.values) {
      pool.addAll(table.multiplication);
      pool.addAll(table.division);
    }
    pool.shuffle();
    return pool;
  }
}
