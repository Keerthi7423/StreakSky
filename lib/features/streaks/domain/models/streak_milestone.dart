enum StreakMilestone {
  none(0, 'None', ''),
  seedling(7, 'Seedling', '🌱'),
  sprout(14, 'Sprout', '🌿'),
  tree(21, 'Tree', '🌳'),
  onFire(30, 'On Fire', '🔥'),
  charged(60, 'Charged', '⚡'),
  unstoppable(90, 'Unstoppable', '💪'),
  star(180, 'Star', '🌟'),
  diamond(365, 'Diamond', '💎'),
  legend(500, 'Legend', '👑');

  final int days;
  final String label;
  final String emoji;

  const StreakMilestone(this.days, this.label, this.emoji);

  static StreakMilestone fromDays(int days) {
    if (days >= 500) return StreakMilestone.legend;
    if (days >= 365) return StreakMilestone.diamond;
    if (days >= 180) return StreakMilestone.star;
    if (days >= 90) return StreakMilestone.unstoppable;
    if (days >= 60) return StreakMilestone.charged;
    if (days >= 30) return StreakMilestone.onFire;
    if (days >= 21) return StreakMilestone.tree;
    if (days >= 14) return StreakMilestone.sprout;
    if (days >= 7) return StreakMilestone.seedling;
    return StreakMilestone.none;
  }
}
