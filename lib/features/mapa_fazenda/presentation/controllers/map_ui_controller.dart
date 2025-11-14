import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/types.dart';

part 'map_ui_controller.g.dart';

@riverpod
class CurrentTool extends _$CurrentTool {
  @override
  DrawTool build() => DrawTool.pencil;
  void setTool(DrawTool tool) => state = tool;
}

@riverpod
class ScreenModeState extends _$ScreenModeState {
  @override
  ScreenMode build() => ScreenMode.viewing;
  
  void toggleMode() {
    state = state == ScreenMode.viewing ? ScreenMode.editing : ScreenMode.viewing;
  }
}

@riverpod
class SelectedIssue extends _$SelectedIssue {
  @override
  IssueType? build() => IssueType.pest; // Default value
  void setIssue(IssueType issue) => state = issue;
}

@riverpod
class IsLoading extends _$IsLoading {
  @override
  bool build() => false;
  void setLoading(bool value) => state = value;
}