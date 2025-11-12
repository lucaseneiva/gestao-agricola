import 'package:desafio_tecnico_arauc/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/mapa_fazenda/ui/mapa_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arauc Agro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MapaScreen(),
    );
  }
}