import 'package:flutter/material.dart';
import 'package:math_facts/repository/math_facts_repository.dart';
import 'package:math_facts/ui/provider/math_facts_provider.dart';
import 'package:math_facts/ui/screens/math_facts_screen/widgets/math_facts_screen.dart';
import 'package:math_facts/ui/screens/settings_screen/widgets/settings_screen.dart';
import 'package:math_facts/ui/theme/app_colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          MathFactsProvider(mathFactsRepository: MathFactsRepository()),
      child: Consumer<MathFactsProvider>(
        builder: (context, mathFactsProvider, _) {
          return MaterialApp(
            title: 'Math Facts',
            theme: ThemeData(
              fontFamily: 'Fredoka',
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.background
              ),
            ),
            initialRoute: MathFactsScreen.routeName,
            routes: {
              MathFactsScreen.routeName: (context) => const MathFactsScreen(),
              SettingsScreen.routeName: (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
