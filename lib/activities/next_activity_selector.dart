import 'activity_models.dart';

/// Selects the next activity without changing activity or progress state.
class NextActivitySelector {
  const NextActivitySelector();

  ActivityDefinition? select({
    required List<ActivityDefinition> activities,
    required Set<String> completedIds,
    String? currentActivityId,
    ActivityType? previousActivityType,
  }) {
    final available = activities.where((activity) {
      if (activity.id == currentActivityId) {
        return false;
      }

      if (completedIds.contains(activity.id)) {
        return false;
      }

      return true;
    }).toList();

    if (available.isEmpty) {
      return null;
    }

    // Prefer a different activity type to keep the child's daily
    // experience varied.
    if (previousActivityType != null) {
      for (final activity in available) {
        if (activity.type != previousActivityType) {
          return activity;
        }
      }
    }

    // Safe fallback: preserve the catalog order.
    return available.first;
  }
}
