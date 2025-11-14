import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';
import '../controllers/date_controller.dart';

class WeekSelector extends ConsumerWidget {
  const WeekSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = ref.watch(currentDateProvider);
    final dateNotifier = ref.read(currentDateProvider.notifier);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavigationButton(
            icon: Icons.chevron_left,
            onPressed: dateNotifier.previousWeek,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${currentDate.year}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(255),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  getWeekDisplayFormat(currentDate),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _NavigationButton(
            icon: Icons.chevron_right,
            onPressed: dateNotifier.nextWeek,
          ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavigationButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}