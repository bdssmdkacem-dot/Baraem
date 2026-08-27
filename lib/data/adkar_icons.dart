/// Baraem Adkar illustration assets.
///
/// The illustrations currently stored in assets/images/ use these exact
/// filenames. Keep this mapping separate from adkar_data.dart so the visual
/// assets can be changed without touching the authenticated dhikr content.
const Map<String, String> adkarIconAssets = {
  'morning': 'assets/images/dhikr_morning.png',
  'evening': 'assets/images/dhikr_evening.png',
  'waking': 'assets/images/dhikr_waking.png',
  'sleep': 'assets/images/dhikr_sleep.png',
  'before_food': 'assets/images/dhikr_before_food.png',
  'after_food': 'assets/images/dhikr_after_food.png',
  'enter_mosque': 'assets/images/dhikr_enter_mosque.png',
  'leave_mosque': 'assets/images/dhikr_leave_mosque.png',
  'enter_home': 'assets/images/dhikr_enter_home.png',
  'leave_home': 'assets/images/dhikr_leave_home.png',
  'riding': 'assets/images/dhikr_riding.png',
};

String? adkarIconFor(String id) {
  if (id.startsWith('morning_')) return adkarIconAssets['morning'];
  if (id.startsWith('evening_')) return adkarIconAssets['evening'];
  return switch (id) {
    'waking' => adkarIconAssets['waking'],
    'sleep' => adkarIconAssets['sleep'],
    'before_food' => adkarIconAssets['before_food'],
    'after_food' => adkarIconAssets['after_food'],
    'enter_mosque' => adkarIconAssets['enter_mosque'],
    'leave_mosque' => adkarIconAssets['leave_mosque'],
    'enter_home' => adkarIconAssets['enter_home'],
    'leave_home' => adkarIconAssets['leave_home'],
    'riding' => adkarIconAssets['riding'],
    _ => null,
  };
}
