import 'package:desafio_tecnico_arauc/core/utils/date_formater.dart';
import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/providers/mapa_state_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapaScreen extends ConsumerStatefulWidget {
  const MapaScreen({super.key});

  @override
  ConsumerState<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends ConsumerState<MapaScreen> {
  late final TransformationController _transformationController;
  final GlobalKey _mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _transformationController = TransformationController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerAndZoomMap();
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  // Agora, mova o método build para dentro desta classe
  @override
  Widget build(BuildContext context) {
    final currentDate = ref.watch(currentDateProvider);
    final screenMode = ref.watch(screenModeStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazenda do Murilo 🍓'),
        actions: [
          IconButton(
            icon: Icon(
              screenMode == ScreenMode.viewing
                  ? Icons.edit_outlined
                  : Icons.check,
              color: screenMode == ScreenMode.viewing
                  ? Colors.white
                  : Colors.lightGreenAccent,
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
                key: _mapKey,
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.black,
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      minScale:
                          1.0, // Não permite diminuir mais que o tamanho original
                      maxScale: 4.0, // Permite um zoom de até 4x
                      boundaryMargin: const EdgeInsets.all(
                        20.0,
                      ), // Margem para arrastar
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          SvgPicture.asset(
                            'assets/images/fazenda_murilo.svg',
                            fit: BoxFit.contain,
                          ),
                          // TODO: O CustomPaint do desenho virá aqui dentro
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dentro de: class _MapaScreenState extends ConsumerState<MapaScreen> { ... }

  void _centerAndZoomMap() {
    final context = _mapKey.currentContext ;
    if(context == null) return;

    // Garante que o widget ainda está na tela antes de fazer qualquer coisa
    if (!mounted || context.size == null) return;
    
    // 1. Defina o nível de zoom inicial que você deseja.
    //    Experimente valores como 1.5, 2.0, etc.
    const double initialScale = 2.5;
    
    // 2. Obtenha o tamanho da "janela" do mapa (o widget Expanded).
    final Size screenSize = context.size!;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // 3. Calcule o deslocamento (translação) necessário para manter o centro.
    //    Quando damos zoom, o tamanho "extra" precisa ser movido para
    //    a esquerda e para cima pela metade, para que o centro permaneça no centro.
    final double tx = -screenWidth * (initialScale - 1) / 2;
    final double ty = -screenHeight * (initialScale - 1) / 2;

    // 4. Crie a matriz de transformação final.
    //    Lembre-se da ordem: primeiro translação, depois escala.
    final Matrix4 initialMatrix = Matrix4.identity()
      ..translate(tx, ty)
      ..scale(initialScale);

    // 5. Aplique a matriz ao nosso controller.
    _transformationController.value = initialMatrix;
  }

  Widget _buildWeekSelector(
    BuildContext context,
    WidgetRef ref,
    DateTime currentDate,
  ) {
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
              backgroundColor: selectedIssue == IssueType.pest
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.sick),
            label: const Text('Doenças'),
            onPressed: () {
              ref
                  .read(selectedIssueProvider.notifier)
                  .setIssue(IssueType.disease);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedIssue == IssueType.disease
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
