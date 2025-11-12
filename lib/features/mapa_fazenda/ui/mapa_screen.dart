import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/providers/mapa_state_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapaScreen extends ConsumerWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A leitura do estado continua igual
    final currentDate = ref.watch(currentDateProvider);
    final screenMode = ref.watch(screenModeStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazenda do Murilo 🍓'),
        actions: [
          IconButton(
            icon: Icon(
              screenMode == ScreenMode.viewing ? Icons.edit_outlined : Icons.check,
              color: screenMode == ScreenMode.viewing ? Colors.white : Colors.lightGreenAccent,
            ),
            onPressed: () {
              // A chamada da lógica agora é um método claro e explícito!
              ref.read(screenModeStateProvider.notifier).toggleMode();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWeekSelector(context, ref, currentDate),
            const SizedBox(height: 16),
            _buildFilterButtons(context, ref),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SvgPicture.asset('assets/images/fazenda_murilo.svg', fit: BoxFit.cover),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSelector(BuildContext context, WidgetRef ref, DateTime currentDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Muito mais legível
            ref.read(currentDateProvider.notifier).previousWeek();
          },
        ),
        Text(
          getWeekDisplayFormat(currentDate),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            // Muito mais legível
            ref.read(currentDateProvider.notifier).nextWeek();
          },
        ),
      ],
    );
  }

  Widget _buildFilterButtons(BuildContext context, WidgetRef ref) {
    // Os nomes dos providers gerados têm "Provider" no final
    final selectedIssue = ref.watch(selectedIssueProvider);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.bug_report),
            label: const Text('Pragas'),
            onPressed: () {
              ref.read(selectedIssueProvider.notifier).setIssue(IssueType.pest);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedIssue == IssueType.pest ? Theme.of(context).colorScheme.primary : Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.sick),
            label: const Text('Doenças'),
            onPressed: () {
              ref.read(selectedIssueProvider.notifier).setIssue(IssueType.disease);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedIssue == IssueType.disease ? Theme.of(context).colorScheme.primary : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}