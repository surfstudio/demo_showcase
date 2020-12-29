import 'package:demo_showcase/domain/library/feedback/feedback_type.dart';

/// Данные об обратной связи
class Feedback {
  Feedback({
    this.name,
    this.email,
    this.phone,
    this.theme,
    this.message,
  });

  final String name;
  final String email;
  final String phone;

  /// Тема сообщения
  final FeedbackType theme;

  /// Сообщение для обратной связи
  final String message;
}
