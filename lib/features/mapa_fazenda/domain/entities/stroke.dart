import '../types.dart';
import 'package:flutter/material.dart';

class Stroke {
  final IssueType issueType;
  final List<Offset> points;

  Stroke({required this.issueType, required this.points});
}
