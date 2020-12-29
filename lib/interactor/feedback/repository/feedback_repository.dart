import 'package:demo_showcase/domain/library/feedback/feedback.dart';

/// Репозиторий для обратной связи
class FeedbackRepository {
  /// Отправить обратную связь
  Future<bool> sendFeedback(Feedback feedback) async {
    Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
