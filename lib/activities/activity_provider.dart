import 'package:flutter/foundation.dart';

import '../providers/character_provider.dart';
import '../providers/progress_provider.dart';
import 'activity_engine.dart';
import 'activity_models.dart';

class ActivityProvider extends ChangeNotifier {
  ActivityProvider({required ProgressProvider progress, required CharacterProvider character})
      : _engine = ActivityEngine(progress: progress, character: character);

  final ActivityEngine _engine;

  ActivityStatus get status => _engine.status;
  ActivityResult? _lastResult;
  ActivityResult? get lastResult => _lastResult;

  void start(ActivityDefinition activity) {
    _engine.start(activity);
    _lastResult = null;
    notifyListeners();
  }

  Future<ActivityResult> complete(ActivityDefinition activity) async {
    final result = await _engine.complete(activity);
    _lastResult = result;
    notifyListeners();
    return result;
  }

  void miss(ActivityDefinition activity) {
    _engine.miss(activity);
    notifyListeners();
  }

  void reset() {
    _engine.reset();
    _lastResult = null;
    notifyListeners();
  }
}
