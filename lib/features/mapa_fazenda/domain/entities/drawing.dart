import 'stroke.dart';

class Drawing {
  final String week;
  final List<Stroke> strokes;

  Drawing({required this.week, this.strokes = const []});

  Drawing copyWith({
    List<Stroke>? strokes,
  }) {
    return Drawing(
      week: week,
      strokes: strokes ?? this.strokes,
    );
  }
}
