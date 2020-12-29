import 'package:get_storage/get_storage.dart';
import 'package:demo_showcase/domain/auth/token_pair.dart';
import 'package:demo_showcase/util/string_utils.dart';
import 'package:demo_showcase/util/extension/storage_extensions.dart';

/// Хранилище токена сессии
class UserStorage {
  UserStorage() {
    _init();
  }
  GetStorage _getStorage;

  static const _keyStorageName = 'USER_STORAGE';
  static const _keyAccessToken = 'KEY_ACCESS_TOKEN';
  static const _keyAccessTokenExpires = 'KEY_ACCESS_TOKEN_EXPIRES';
  static const _keyRefreshToken = 'KEY_REFRESH_TOKEN';
  static const _keyPhoneNumber = 'PHONE_NUMBER';

  Future<void> _init() async {
    await GetStorage.init(_keyStorageName);
    _getStorage = GetStorage(_keyStorageName);
  }

  String getPhoneNumber() {
    return _getStorage.get(
      _keyPhoneNumber,
      defaultValue: EMPTY_STRING,
    );
  }

  TemporaryToken getAccessToken() {
    return TemporaryToken.fromStrings(
      value: _getStorage.get(_keyAccessToken, defaultValue: EMPTY_STRING),
      dateIsoFormat:
          _getStorage.get(_keyAccessTokenExpires, defaultValue: EMPTY_STRING),
    );
  }

  Token getRefreshToken() {
    return Token(
      _getStorage.get(
        _keyRefreshToken,
        defaultValue: EMPTY_STRING,
      ),
    );
  }

  Future<TokenPair> saveTokens(TokenPair tokens) => Future.wait(
        [
          saveAccessToken(tokens.access),
          saveRefreshToken(tokens.refresh),
        ],
      ).then((value) => tokens);

  Future<void> savePhoneNumber(String number) async {
    return _getStorage.write(_keyPhoneNumber, number);
  }

  Future<void> saveAccessToken(TemporaryToken token) async {
    await _getStorage.write(_keyAccessToken, token.value);
    await _getStorage.write(
      _keyAccessTokenExpires,
      token.expiresIn.toIso8601String(),
    );
  }

  Future<void> saveRefreshToken(Token token) async {
    await _getStorage.write(_keyRefreshToken, token.value);
  }

  Future<void> clearData() async {
    return _getStorage.erase();
  }
}
