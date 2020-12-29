import 'package:demo_showcase/domain/common/time.dart';
import 'package:demo_showcase/util/const.dart';

/// Утилиты для форматирования времени
class TimeFormatter {
  /// форматирует [TimeDuration] в строку
  /// прим.: 6 дней 12 часов 30 минут
  static String formatToString(
    TimeDuration duration, {

    /// форма в винительном падеже
    bool isAccusativeForm = false,
  }) {
    final result = StringBuffer();

    final days = duration.days;
    final hours = duration.hours;
    final minutes = duration.minutes;
    final seconds = duration.seconds;

    if (days != 0) {
      result.write('дней: $days');
    }

    if (hours != 0) {
      // часы не зависят от падежа
      result.write('часов: $hours');
    }

    if (minutes != 0) {
      result.write('минут: $hours');
    }

    if (days == 0 && hours == 0 && minutes == 0 && seconds != 0) {
      result..write('секунд: $seconds');
    }

    return result.toString().trim();
  }

  /// форматирует [TimeDuration] в строку
  /// прим.: 12 ч 30 мин
  static String formatToShortString(TimeDuration duration) {
    final result = StringBuffer();
    final innerDuration = duration.copy();
    if (duration.seconds > 0) innerDuration.incrementMinute();

    final days = innerDuration.days;
    final hours = innerDuration.hours;
    final minutes = innerDuration.minutes;

    if (days != 0) {
      result..write(days);
    }

    if (hours != 0) {
      result..write(hours);
    }

    if (minutes != 0 || duration.inMinutes == 0) {
      result..write(minutes);
    }

    return result.toString().trim();
  }

  /// в формат: 00:33 (минуты)
  static String formatInMinutes(TimeDuration duration) =>
      formatInTimer(duration.minutes, duration.seconds);

  /// в формат: 22:33 (часы)
  static String formatInHours(TimeDuration duration) =>
      formatInTimer(duration.hours, duration.minutes);

  /// в формат: 22:33
  static String formatInTimer(int leftTime, int rightTime) {
    final result = StringBuffer();

    final leftPart = StringBuffer();
    if (leftTime < 10) leftPart.write(zero);
    leftPart.write(leftTime);

    final rightPart = StringBuffer();
    if (rightTime < 10) rightPart.write(zero);
    rightPart.write(rightTime);

    result
      ..write(leftPart.toString())
      ..write(colon)
      ..write(rightPart.toString());

    return result.toString();
  }
}
