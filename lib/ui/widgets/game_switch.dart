import 'package:flutter/material.dart';
import 'package:math_facts/ui/theme/app_colors.dart';

class GameSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const GameSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value, 
      onChanged: onChanged,
      activeThumbColor: AppColors.accent,
      inactiveThumbColor: AppColors.onBackground,
      activeTrackColor: AppColors.primary.withAlpha(150),
      inactiveTrackColor: AppColors.background.withAlpha(150),
      activeThumbImage: AssetImage('assets/images/switch_thumb_active.png'),
      inactiveThumbImage: AssetImage('assets/images/switch_thumb_inactive.png'),
    );
  }
}
