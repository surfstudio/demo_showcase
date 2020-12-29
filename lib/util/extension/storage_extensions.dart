import 'package:get_storage/get_storage.dart';

/// Расширение для [GetStorage]
extension GetStorageExtension on GetStorage {
  /// Получение значение из хранилище
  /// с возможностью подстановки стандартного значение
  T get<T>(String key, {T defaultValue}) {
    if (hasData(key)) {
      return read(key);
    } else {
      return defaultValue;
    }
  }
}
