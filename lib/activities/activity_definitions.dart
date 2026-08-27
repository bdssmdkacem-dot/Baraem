import 'activity_models.dart';

ActivityDefinition adhkarActivity(String id, String title) => ActivityDefinition(
      id: id,
      title: title,
      type: ActivityType.adhkar,
    );

ActivityDefinition mannersActivity(String id, String title) => ActivityDefinition(
      id: id,
      title: title,
      type: ActivityType.manners,
    );

ActivityDefinition storyActivity(String id, String title) => ActivityDefinition(
      id: id,
      title: title,
      type: ActivityType.stories,
    );
