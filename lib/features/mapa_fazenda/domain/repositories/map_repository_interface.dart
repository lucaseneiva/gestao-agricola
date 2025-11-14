import '../entities/drawing.dart';

abstract class IMapRepository {
  Future<Drawing?> getDraw(String weekNumber);
  Future<void> saveDraw(Drawing drawing);
  Future<void> deleteDraw(String weekNumber);
}
