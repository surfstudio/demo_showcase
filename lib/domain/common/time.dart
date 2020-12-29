import 'package:flutter/foundation.dart';
import 'package:demo_showcase/util/const.dart';
import 'package:demo_showcase/util/time_formatter.dart';

/// Обёртка над Duration для вычисления кол-ва дней, часов, минут и т.д.
///
/// особенности:
/// - 100 сек => 1 минута 40 сек
/// - 30 часов => 1 день 6 часов
class TimeDuration {
  TimeDuration(this._innerDuration);

  TimeDuration.fromSeconds(int seconds) : this(Duration(seconds: seconds));

  Duration _innerDuration;

  ///период в минутах
  int get inMinutes => _innerDuration.inMinutes;

  ///период в секундах
  int get inSeconds => _innerDuration.inSeconds;

  ///кол-во дней
  int get days => _innerDuration.inDays;

  ///кол-во часов
  int get hours =>
      _innerDuration.inHours - (_innerDuration.inDays * hoursInDay);

  ///кол-во минут
  int get minutes =>
      _innerDuration.inMinutes - (_innerDuration.inHours * minutesInHour);

  ///кол-во секунд
  int get seconds =>
      _innerDuration.inSeconds - (_innerDuration.inMinutes * secondsInMinute);

  ///увеличение периода на 1 минуту
  void incrementMinute() {
    var newMinutes = _innerDuration.inMinutes;
    _innerDuration = Duration(minutes: ++newMinutes);
  }

  ///уменьшение периода на 1 минуту
  void decrementMinute() {
    var newMinutes = _innerDuration.inMinutes;
    _innerDuration = Duration(minutes: --newMinutes);
  }

  /// Возвращает копию
  TimeDuration copy() => TimeDuration(_innerDuration);
}

@immutable
class TimeRange {
  const TimeRange(this.from, this.to);

  final Duration from;
  final Duration to;

  Duration get length => to - from;

  bool inRange(Duration checkDuration) =>
      from < checkDuration && to > checkDuration;

  @override
  String toString() {
    final leftFormatted = TimeFormatter.formatInMinutes(TimeDuration(from));
    final rightFormatted = TimeFormatter.formatInMinutes(TimeDuration(to));
    return '[$leftFormatted:$rightFormatted]';
  }

  @override
  bool operator ==(Object other) =>
      other is TimeRange &&
      other.from.inSeconds == from.inSeconds &&
      other.to.inSeconds == to.inSeconds;

  @override
  int get hashCode => from.hashCode + to.hashCode;
}
