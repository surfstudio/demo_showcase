import 'package:flutter/widgets.dart';

///
/// Набор констант для размеров элементов UI
///

/// высота аппбара на многих экранах
const double toolbarHeight = 56.0;

/// радиусы элементов, с использованием const
const borderRadius20 = BorderRadius.all(Radius.circular(20.0));
const borderRadius16 = BorderRadius.all(Radius.circular(16.0));

/// Граничная ширина экрана телефона, ниже которой применяется
/// масштабирование верстки
const double smallPhoneWidth = 380.0;
const double extraSmallPhoneWidth = 340.0;

/// Смещение скрола для загрузки следующей страницы при пагинации
const offsetToLoadNewPage = 100;

/// Отступ в списке контролов у карточки
const cardActionsBetweenPadding = 16.0;

/// Название анимации по умолчанию
const baseAnimationName = 'start';

/// Утилиты для UI
class UiUtils {
  UiUtils._();

  /// Считается ли экран маленьким
  static bool isScreenSmall(BuildContext context) =>
      MediaQuery.of(context).size.width <= smallPhoneWidth;
}
