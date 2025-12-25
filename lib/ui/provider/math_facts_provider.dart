import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_facts/models/math_facts.dart';
import 'package:math_facts/repository/math_facts_repository.dart';

class MathFactsProvider extends ChangeNotifier {
  final MathFactsRepository mathFactsRepository;
  List<MathFact> availableFacts = [];
  List<TableFacts> tables = [];
  Map<TableFacts, bool> tablesSelection = {};
  MathFactsProvider({required this.mathFactsRepository}) {
    _initialize();
  }

  Future<void> _initialize() async {
    tables = await mathFactsRepository.loadTables();
    tablesSelection = {for (var e in tables) e: true};
    filterTables();
  }

  void filterTables() {
    availableFacts.clear();
    for (final table in tables) {
      final factNumber = table.table;
      final tableSelected = tablesSelection.entries
          .firstWhere((element) => element.key.table == factNumber)
          .value;
      if (tableSelected) {
        availableFacts.addAll(table.multiplication);
        availableFacts.addAll(table.division);
      }
    }
    availableFacts.shuffle();
    notifyListeners();
  }

  MathFact randomExercise() {
    final rnd = Random();
    return availableFacts[rnd.nextInt(availableFacts.length)];
  }
}
