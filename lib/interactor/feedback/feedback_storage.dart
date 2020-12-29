import 'package:get_storage/get_storage.dart';
import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/domain/library/feedback/feedback_local_info.dart';

const _nameKey = 'feedback-name';
const _phoneKey = 'feedback-phone';
const _emailKey = 'feedback-email';
const _countyCodeKey = 'feedback-country-code';

class FeedbackStorage {
  FeedbackStorage(this._instance);

  final GetStorage _instance;

  /// Проверяет есть ли данные в хранилище
  bool get hasLocalData {
    return _instance.hasData(_nameKey) &&
        _instance.hasData(_phoneKey) &&
        _instance.hasData(_emailKey);
  }

  /// Получение локальной информации об обратной связи
  FeedbackLocalInfo getFeedbackLocalInfo() {
    final name = _instance.read<String>(_nameKey);
    final phone = _instance.read<String>(_phoneKey);
    final email = _instance.read<String>(_emailKey);
    final country = Country.byCode('');

    return FeedbackLocalInfo(
      name: name,
      phone: phone,
      email: email,
      country: country,
    );
  }

  /// Сохранение локальной информации об обратной связи
  Future<void> setFeedbackLocalInfo(FeedbackLocalInfo info) async {
    await _instance.write(_nameKey, info.name);
    await _instance.write(_phoneKey, info.phone);
    await _instance.write(_emailKey, info.email);
    await _instance.write(_countyCodeKey, info.country.code);
  }
}
