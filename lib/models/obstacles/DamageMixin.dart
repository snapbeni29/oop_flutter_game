abstract class DamageMixin {
  int maxHealth;
  int health;

  void damage() {
    health--;
  }

  bool get dead => health <= 0;
}