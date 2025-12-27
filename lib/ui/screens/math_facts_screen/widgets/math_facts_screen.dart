import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:math_facts/ui/provider/math_facts_provider.dart';
import 'package:math_facts/ui/screens/math_facts_screen/view_model/math_facts_view_model.dart';
import 'package:math_facts/ui/screens/settings_screen/widgets/settings_screen.dart';
import 'package:math_facts/ui/theme/app_colors.dart';
import 'package:math_facts/ui/widgets/game_button.dart';
import 'package:provider/provider.dart';
import 'package:typewritertext/typewritertext.dart';

class MathFactsScreen extends StatefulWidget {
  static const routeName = '/math-facts';
  const MathFactsScreen({super.key});

  @override
  State<MathFactsScreen> createState() => _MathFactsScreenState();
}

class _MathFactsScreenState extends State<MathFactsScreen> {
  final ConfettiController confettiController = ConfettiController(
    duration: const Duration(seconds: 1),
  );

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MathFactsViewModel>(
      create: (_) => MathFactsViewModel(
        mathFactsProvider: Provider.of<MathFactsProvider>(context),
      ),
      child: Consumer<MathFactsViewModel>(
        builder: (context, viewModel, child) {
          Logger().d(
            'Current state: ${viewModel.currentState}, Answer state: ${viewModel.answerState}',
          );
          if (viewModel.currentState == MathFactsState.solved &&
              viewModel.answerState == AnswerState.correct) {
            Logger().d('if loop accessed to play confetti');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              confettiController.play();
            });
          }

          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  leading: Image.asset(
                    'assets/images/app_logo_no_bg.png',
                    height: 48,
                  ),
                  title: Text(
                    'Tafel Trainer',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: AppColors.background,
                ),
                backgroundColor: AppColors.background,
                body: Stack(
                  children: [
                    FeedbackOwl(),
                    Center(
                      child: viewModel.exercisesAvailable
                          ? MathFactsView()
                          : CircularProgressIndicator(color: AppColors.accent),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/grass.png'),
                            fit: BoxFit.fitHeight,
                            repeat: ImageRepeat.repeatX,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 32,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.earth,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(51),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '© 2025 thpir. All rights reserved. Application created by Thijs Pirmez',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.onEarth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ConfettiWidget(
                confettiController: confettiController,
                blastDirection: -pi / 2,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 100,
                maxBlastForce: 20,
              ),
            ],
          );
        },
      ),
    );
  }
}

class FeedbackOwl extends StatelessWidget {
  const FeedbackOwl({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MathFactsViewModel>(context);
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (viewModel.currentState == MathFactsState.solved) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                alignment: Alignment.center,
                width: 200,
                height: 100,
                child: TypeWriter.text(
                  maxLines: 2,
                  duration: Duration(milliseconds: 50),
                  maintainSize: false,
                  viewModel.answerState == AnswerState.incorrect
                      ? 'Spijtig... het juiste antwoord was: ${viewModel.fact!.result}'
                      : 'Helemaal juist! Goed Gedaan!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: ClipPath(
                  clipper: TriangleClipper(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 8),
            ],

            Image.asset('assets/images/owl.png', height: 150),
          ],
        ),
      ),
    );
  }
}

class MathFactsView extends StatefulWidget {
  const MathFactsView({super.key});

  @override
  State<MathFactsView> createState() => _MathFactsViewState();
}

class _MathFactsViewState extends State<MathFactsView> {
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MathFactsViewModel>(
        context,
        listen: false,
      ).displayNewExercise();
    });
    super.initState();
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void next() {
    answerController.clear();
    Provider.of<MathFactsViewModel>(
      context,
      listen: false,
    ).displayNewExercise();
  }

  void checkAnswer() {
    FocusScope.of(context).unfocus();
    Provider.of<MathFactsViewModel>(
      context,
      listen: false,
    ).checkAnswer(int.parse(answerController.text));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MathFactsViewModel>(context, listen: false);

    return viewModel.fact == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    Text(
                      '${viewModel.fact!.expression} = ',
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      width: 90,
                      child: TextField(
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              color: AppColors.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                        controller: answerController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],

                        onChanged: (value) {
                          setState(() {});
                        },
                        cursorColor: AppColors.accent,
                        decoration: InputDecoration(
                          hintText: '...',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: AppColors.onBackground,
                                fontWeight: FontWeight.bold,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.onBackground,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.accent,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    if (viewModel.exercisesAvailable)
                      GameButton(
                        imagePath: 'assets/images/settings.png',
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            SettingsScreen.routeName,
                          );
                          next();
                        },
                      ),
                    GameButton(
                      imagePath: 'assets/images/next.png',
                      onPressed: next,
                    ),
                    GameButton(
                      imagePath:
                          answerController.text.isEmpty ||
                              viewModel.currentState == MathFactsState.solved
                          ? 'assets/images/check_inactive.png'
                          : 'assets/images/check_active.png',
                      onPressed:
                          answerController.text.isEmpty ||
                              viewModel.currentState == MathFactsState.solved
                          ? null
                          : checkAnswer,
                    ),
                  ],
                ),
                // if (viewModel.currentState == MathFactsState.solved &&
                //     viewModel.answerState == AnswerState.incorrect) ...[
                //   Text(
                //     'Het juiste antwoord is: ${viewModel.fact!.result}',
                //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //       color: AppColors.error,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ],
              ],
            ),
          );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Top-center
    path.moveTo(0, size.height / 2);
    // Bottom-right
    path.lineTo(size.width, 0);
    // Bottom-left
    path.lineTo(0, size.height);
    path.close(); // back to top-center
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
