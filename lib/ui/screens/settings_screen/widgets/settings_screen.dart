import 'package:flutter/material.dart';
import 'package:math_facts/ui/provider/math_facts_provider.dart';
import 'package:math_facts/ui/screens/settings_screen/view_model/settings_view_model.dart';
import 'package:math_facts/ui/theme/app_colors.dart';
import 'package:math_facts/ui/widgets/game_button.dart';
import 'package:math_facts/ui/widgets/game_switch.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final mathFactsProvider = Provider.of<MathFactsProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => SettingsViewModel(
        mathFactsProvider: mathFactsProvider,
      ), // Inject MathFactsProvider
      child: Scaffold(
        appBar: AppBar(
          leading: Center(
            child: GameButton(
              onPressed: () => Navigator.pop(context),
              imagePath: 'assets/images/back.png',
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: AppColors.background,
        body: SettingsView(),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);

    List<Widget> tableButtons() {
      List<Widget> buttons = [];
      for (final tableSelection
          in viewModel.mathFactsProvider.tablesSelection.entries) {
        final table = tableSelection.key;
        final selected = tableSelection.value;
        buttons.add(
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tafel van ${table.table}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GameSwitch(
                value: selected, onChanged: (bool newValue) {
                  viewModel.mathFactsProvider.tablesSelection[table] = newValue;
                  viewModel.mathFactsProvider.filterTables();
                },
              )
            ],
          ),
        );
      }
      return buttons;
    }

    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selecteer de tafels die je wilt oefenen:',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.bold,
                          )),
                  const SizedBox(height: 16),
                  ...tableButtons()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
