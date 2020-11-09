/*
  A button will react differently based on its type
    -> run and jump have special mechanisms
        (see ButtonRun.dart and ButtonJump.dart)
    -> an instant button only reacts to short/instant taps.
 */

enum ButtonType {
  run,
  instant,
  jump
}