import 'package:desafio_tecnico_arauc/features/mapa_fazenda/ui/providers/mapa_state_providers.dart';
import 'package:flutter/material.dart';

class Stroke {
  final IssueType issueType;
  final List<Offset> points;

  Stroke({required this.issueType, required this.points});
}
