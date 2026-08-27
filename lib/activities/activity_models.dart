import 'package:flutter/foundation.dart';

enum ActivityType { adhkar, manners, stories, games }

enum ActivityStatus { available, inProgress, completed, missed }

@immutable
class ActivityDefinition {
  const ActivityDefinition({
    required this.id,
    required this.title,
    required this.type,
    this.description = '',
  });

  final String id;
  final String title;
  final ActivityType type;
  final String description;
}

@immutable
class ActivityResult {
  const ActivityResult({
    required this.activityId,
    required this.completed,
    this.starsEarned = 0,
  });

  final String activityId;
  final bool completed;
  final int starsEarned;
}
