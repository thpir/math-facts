import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:math_facts/models/math_facts.dart';
import 'package:math_facts/ui/provider/math_facts_provider.dart';

class MathFactsViewModel extends ChangeNotifier {
  final MathFactsProvider mathFactsProvider;
  MathFact? fact;
  late int solution;
  MathFactsState currentState = MathFactsState.unsolved;
  AnswerState answerState = AnswerState.incorrect;

  MathFactsViewModel({required this.mathFactsProvider}) {
    mathFactsProvider.addListener(notifyListeners);
  }

  bool get exercisesAvailable => mathFactsProvider.availableFacts.isNotEmpty;

  @override
  void dispose() {
    mathFactsProvider.removeListener(notifyListeners);
    super.dispose();
  }

  void displayNewExercise() {
    currentState = MathFactsState.unsolved;
    _fetchNewFact();
  }

  void checkAnswer(int anwser) {
    currentState = MathFactsState.solved;
    if (anwser == solution) {
      answerState = AnswerState.correct;
      Logger().d('Correct answer: $anwser');
    } else {
      answerState = AnswerState.incorrect;
    }
    notifyListeners();
  }

  void _fetchNewFact() {
    fact = mathFactsProvider.randomExercise();
    solution = fact!.result;
    notifyListeners();
  }
}

enum MathFactsState { unsolved, solved }

enum AnswerState { correct, incorrect }
