import '../providers/character_provider.dart';
import '../providers/progress_provider.dart';
import 'activity_models.dart';

class ActivityEngine {
  ActivityEngine({required this.progress, required this.character});

  final ProgressProvider progress;
  final CharacterProvider character;

  ActivityStatus _status = ActivityStatus.available;
  ActivityStatus get status => _status;

  void start(ActivityDefinition activity) {
    if (progress.isCompleted(activity.id)) {
      _status = ActivityStatus.completed;
      return;
    }
    _status = ActivityStatus.inProgress;
    character.onActivityStarted();
  }

  Future<ActivityResult> complete(ActivityDefinition activity) async {
    if (_status != ActivityStatus.inProgress || progress.isCompleted(activity.id)) {
      return ActivityResult(activityId: activity.id, completed: false);
    }

    _status = ActivityStatus.completed;
    character.onActivityCompleted();
    await progress.markCompleted(activity.id);
    character.onStarEarned();
    return ActivityResult(activityId: activity.id, completed: true, starsEarned: 1);
  }

  void miss(ActivityDefinition activity) {
    if (_status != ActivityStatus.inProgress) return;
    _status = ActivityStatus.missed;
    character.onActivityMissed();
  }

  void reset() => _status = ActivityStatus.available;
}
