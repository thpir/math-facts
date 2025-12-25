import 'package:flutter/material.dart';
import 'package:math_facts/ui/provider/math_facts_provider.dart';

class SettingsViewModel extends ChangeNotifier {
  final MathFactsProvider mathFactsProvider;

  SettingsViewModel({required this.mathFactsProvider}) {
    mathFactsProvider.addListener(notifyListeners);
  }

  @override
  void dispose() {
    mathFactsProvider.removeListener(notifyListeners);
    super.dispose();
  }

  get rangeMeta => mathFactsProvider.mathFactsRepository.rangeMeta;
}