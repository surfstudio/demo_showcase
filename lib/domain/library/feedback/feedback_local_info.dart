import 'package:flutter/foundation.dart';
import 'package:demo_showcase/domain/country/country.dart';

/// Данные о пользователе, сохраняемые локально для последующей отправки
/// обратной связи
@immutable
class FeedbackLocalInfo {
  const FeedbackLocalInfo({
    this.name,
    this.phone,
    this.email,
    this.country,
  });

  FeedbackLocalInfo.empty()
      : this(
          name: '',
          phone: '',
          email: '',
          country: rusCountry,
        );

  final String name;
  final String phone;
  final String email;
  final Country country;

  FeedbackLocalInfo copyWith({
    String name,
    String phone,
    String email,
    Country country,
  }) {
    return FeedbackLocalInfo(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      country: country ?? this.country,
    );
  }
}
