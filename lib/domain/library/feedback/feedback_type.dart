/// Тип сообщения обратной связи
enum FeedbackType {
  /// Пустой
  none,

  /// Жалоба
  complaint,

  /// Предложения
  suggestion,

  /// Другое
  other,
}

extension FeedbackTypeExtensions on FeedbackType {
  /// Название для типа
  String get title {
    switch (this) {
      case FeedbackType.none:
        return 'Тема сообщения';

      case FeedbackType.complaint:
        return 'Жалоба';

      case FeedbackType.suggestion:
        return 'Предложение';

      case FeedbackType.other:
        return 'Другое';
    }
  }
}
