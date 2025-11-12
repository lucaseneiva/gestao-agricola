import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos o Theme.of(context) para pegar cores se precisarmos de algo específico
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // Não precisamos mais de cores aqui, elas vêm do appBarTheme!
        title: const Text('Fazenda do Murilo 🍓'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              print("Botão Editar clicado");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWeekSelector(context),
            const SizedBox(height: 16),
            _buildFilterButtons(context),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SvgPicture.asset(
                      'assets/images/fazenda_murilo.svg',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            print("Semana anterior");
          },
        ),
        const Text(
          'Semana 42 (20/10 - 26/10)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            print("Próxima semana");
          },
        ),
      ],
    );
  }

  Widget _buildFilterButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.bug_report),
            label: const Text('Pragas'),
            onPressed: () {
              print("Botão Pragas clicado");
            },
            
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.sick),
            label: const Text('Doenças'),
            onPressed: () {
              print("Botão Doenças clicado");
            },
            // O style não é mais necessário aqui também!
          ),
        ),
      ],
    );
  }
}
