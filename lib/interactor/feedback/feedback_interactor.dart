import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/domain/library/feedback/feedback.dart';
import 'package:demo_showcase/domain/library/feedback/feedback_local_info.dart';
import 'package:demo_showcase/interactor/feedback/feedback_storage.dart';
import 'package:demo_showcase/interactor/feedback/repository/feedback_repository.dart';

/// Интерактор для обратной связи
class FeedbackInteractor {
  FeedbackInteractor(
    this._storage,
    this._repository,
  );

  final FeedbackStorage _storage;
  final FeedbackRepository _repository;

  /// Проверяет есть ли данные в хранилище
  bool get hasLocalData => _storage.hasLocalData;

  /// Получение локальной информации об обратной связи
  FeedbackLocalInfo getFeedbackLocalInfo() {
    return _storage.getFeedbackLocalInfo();
  }

  /// Сохранение локальной информации об обратной связи
  Future<void> setFeedbackLocalInfo(FeedbackLocalInfo info) {
    return _storage.setFeedbackLocalInfo(info);
  }

  /// Сохранить телефон
  Future<void> savePhone(String phone, Country country) {
    FeedbackLocalInfo info = FeedbackLocalInfo.empty();

    if (hasLocalData) {
      info = getFeedbackLocalInfo();
    }

    final updatedInfo = info.copyWith(
      phone: phone.substring(country.dialCode.length),
      country: country,
    );
    return setFeedbackLocalInfo(updatedInfo);
  }

  /// Отправить обратную связь
  Future<bool> sendFeedback(Feedback feedback) {
    return _repository.sendFeedback(feedback);
  }
}
