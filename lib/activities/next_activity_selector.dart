import 'activity_models.dart';

/// Selects the next activity without changing activity or progress state.
class NextActivitySelector {
  const NextActivitySelector();

  ActivityDefinition? select({
    required List<ActivityDefinition> activities,
    required Set<String> completedIds,
    String? currentActivityId,
  }) {
    for (final activity in activities) {
      if (activity.id == currentActivityId) continue;
      if (completedIds.contains(activity.id)) continue;
      return activity;
    }

    return null;
  }
}
