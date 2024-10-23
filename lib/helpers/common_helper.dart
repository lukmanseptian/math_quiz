import 'dart:math';

class CommonHelper {
  const CommonHelper();

  //? Knuth Shuffle Menggunakan Bahasa Dart
  static void knuthShuffle(List list) {
    final random = Random();
    for (int i = list.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  //? Mengubah Timer Detik Menjadi Format 00:00
  static String formatTimer(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;

    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }
}
