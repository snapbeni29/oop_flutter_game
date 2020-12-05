import 'package:corona_bot/Body.dart';
import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/obstacles/PlatformController.dart';
import 'package:corona_bot/controllers/obstacles/ProjectileController.dart';

/// Implements some shoot related functions and some functions to override.
abstract class ShooterMixin {
  // Variables used for the projectiles
  List<ProjectileController> projectileList = List();
  int aliveProjectile = 0;
  int maxProjectile = 3;
  bool firstShoot = false;

  // Constants
  double pixelWidth;
  double pixelHeight;

  /// As startProjectile() will implement a timer, it needs an end() to stop it.
  void end();

  /// If this is the firstShoot (firstShoot = false as it has not been done
  /// yet), we start the timer with the startProjectile function to override.
  /// Else, we add a new projectile to the list if possible.
  ///
  void shootMixin(Direction direction, bool freezing, Body projectileBody,
      {double yAngle = 0}) {
    // Shoot if there is not already _maxProjectile
    if (aliveProjectile < maxProjectile) {
      if (!firstShoot) {
        firstShoot = true;
        startProjectile(); // start timer
      }
      projectileList.add(new ProjectileController(
          projectileBody, direction, freezing, yAngle));
      aliveProjectile++;
    }
  }

  void startProjectile();

  /// Remove the projectiles that collide with a platform, or that get out of
  /// the screen.
  void removeCollideProjectilesPlatforms(
      List<PlatformController> platformList) {
    List<ProjectileController> toRemove = <ProjectileController>[];
    for (ProjectileController projectile in projectileList) {
      bool collide = false;
      // Collide with a platform
      for (PlatformController pt in platformList) {
        if(pt.body.x < 1 && pt.body.x > -1) {
          if (projectile.body.collide(pt.body, pixelWidth, pixelHeight)) {
            collide = true;
            aliveProjectile--;
            toRemove.add(projectile);
            break;
          }
        }
      }
      if (!collide) {
        bool outOfScreen = ((projectile.direction == Direction.STILL_RIGHT ||
                    projectile.direction == Direction.RIGHT) &&
                projectile.body.x > 1.1) ||
            ((projectile.direction == Direction.STILL_LEFT ||
                    projectile.direction == Direction.LEFT) &&
                projectile.body.x < -1.1);

        if (outOfScreen) {
          aliveProjectile--;
          toRemove.add(projectile);
        }
      }
    }
    if (toRemove.isNotEmpty) {
      projectileList.removeWhere((e) => toRemove.contains(e));
    }
  }
}
