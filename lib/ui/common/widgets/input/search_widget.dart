import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:demo_showcase/ui/common/widgets/layout/material_container.dart';
import 'package:demo_showcase/util/string_utils.dart';

/// Коллбэк на ввод в поисковую строку
typedef SearchCallback = void Function(String input);

const Duration _cancelBtnAnimationDuration = Duration(milliseconds: 80);
const Duration _openKeyboardDuration = Duration(milliseconds: 20);
const Duration _pressStateAnimationDuration = Duration(milliseconds: 300);

/// Виджет с поисковой строкой и кнопкой отмена
///
/// имеет 2 состояния:
/// - в качестве поля ввода
/// - в качестве кнопки, без возможности ввода
///   (для этого надо не передавать [onSearchPressed])
class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key key,
    this.onSearchInput,
    this.onSearchPressed,
    this.onMicroPressed,
    this.isNeedCancelButton = true,
    this.onCancelTap,
    this.onSubmitted,
    this.haveAutoFocus = false,
    this.text,
    this.controller,
    this.focusNode,
    this.isShowAlwaysCancelButton = false,
    this.isHideClearTextBtn = false,
    this.isClearTextOnCancelBtn = true,
    this.hint,
  }) : super(key: key);

  /// нажатие на строку поиска
  ///
  /// если null, то доступен ввод
  final VoidCallback onSearchPressed;

  /// нажатие на кнопку микрофона в поиске
  ///
  /// если null, то кнопка микрофона скрывается
  final VoidCallback onMicroPressed;

  /// колбэк на ввод строки в поисковую строку
  ///
  /// если есть колбэк на нажатие, то ввод невозможен
  final SearchCallback onSearchInput;

  /// дополнительная обработка нажатия на кнопку Отмена
  ///
  /// если null, то только очищает список и убирает фокус
  final VoidCallback onCancelTap;

  /// колбэк на нажатие кнопки поиск на клавиатуре
  ///
  /// если есть колбэк на нажатие, то после нажатия выполняется функция
  final SearchCallback onSubmitted;

  /// Нужна ли кнопка Отмена
  ///
  /// По нажатию на кнопку стирается текстовое поле и сбрасывается фокус
  final bool isNeedCancelButton;

  /// опцианально вместе с [isNeedCancelButton]
  final bool isShowAlwaysCancelButton;

  /// опциально
  /// показывать ли крестик для очистки без фокуса в поле ввода
  final bool isHideClearTextBtn;

  /// опциально
  /// очищать ли поле ввода по кнопке Отмена
  final bool isClearTextOnCancelBtn;

  /// Автофокус на текстовом поле
  ///
  /// Если  true, то поле получает фокус как толкьо сможет
  final bool haveAutoFocus;

  /// Стартовый текст
  final String text;

  /// Текст подсказки
  final String hint;

  /// Контроллер ввода поисковой строки
  final TextEditingController controller;

  /// Управление фокусом поисковой строки
  final FocusNode focusNode;

  @override
  // ignore: no_logic_in_create_state
  _SearchWidgetState createState() => _SearchWidgetState(controller, focusNode);
}

class _SearchWidgetState extends State<SearchWidget>
    with TickerProviderStateMixin {
  _SearchWidgetState(this._controller, this._focusNode);

  static const double _height = 36.0;
  static const double _borderRadius = 20.0;
  static final InputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(_borderRadius),
  );

  bool isEmpty = true;
  String currentInputText = EMPTY_STRING;
  bool needShowCancelBtn = false;

  TextEditingController _controller;
  FocusNode _focusNode;

  AnimationController _searchAnimationController;
  Animation<Color> _searchBackgroundColorTween;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: _pressStateAnimationDuration,
    );
    _searchBackgroundColorTween =
        ColorTween(begin: Colors.grey, end: Colors.grey.withAlpha(150))
            .animate(_searchAnimationController);
    _searchAnimationController.addListener(() {
      setState(() {});
    });
    _controller ??= TextEditingController();
    _focusNode ??= FocusNode();
    _focusNode.addListener(() {
      setState(() {
        needShowCancelBtn =
            widget.isShowAlwaysCancelButton || _focusNode.hasFocus;
      });
    });
    _controller.addListener(_handleInput);
    if (widget.text != null && widget.text.isNotEmpty) {
      _controller.text = widget.text;
      isEmpty = false;
    }
    if (widget.haveAutoFocus) {
      Future<void>.delayed(_openKeyboardDuration).then(
        (_) => _focusNode.requestFocus(),
      );
    }
  }

  @override
  void didUpdateWidget(SearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != null) {
      _controller.text = widget.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCallback = widget.onSearchPressed != null;
    if (hasCallback) {
      return _buildClickableInput(context);
    } else {
      return _buildTextField(context);
    }
  }

  Widget _buildClickableInput(BuildContext context) {
    return GestureDetector(
      onTapCancel: () {
        _searchAnimationController.reverse();
      },
      onTap: () {
        widget.onSearchPressed();
      },
      onTapDown: (details) {
        _searchAnimationController.forward();
      },
      onTapUp: (details) {
        _searchAnimationController.reverse();
      },
      child: SizedBox(
        height: _height,
        child: InputDecorator(
          isEmpty: true,
          decoration: _buildDecoration(context),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    final theme = Theme.of(context);
    final constraint = needShowCancelBtn ? double.infinity : 0.0;
    final heightConstraint = needShowCancelBtn ? _height : 0.0;
    return Row(
      children: <Widget>[
        Expanded(
          child: MaterialContainer(
            height: _height,
            child: TextField(
              controller: _controller,
              autocorrect: false,
              focusNode: _focusNode,
              cursorColor: theme.accentColor,
              textInputAction: TextInputAction.search,
              onSubmitted: widget.onSubmitted,
              decoration: _buildDecoration(context),
            ),
          ),
        ),
        widget.isNeedCancelButton
            ? AnimatedSize(
                vsync: this,
                duration: _cancelBtnAnimationDuration,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: heightConstraint,
                    maxWidth: constraint,
                  ),
                  alignment: Alignment.center,
                  child: CupertinoTheme(
                    child: CupertinoButton(
                      onPressed: _handleCancelBtn,
                      padding: const EdgeInsets.only(
                          left: 16, top: 10.0, bottom: 10.0),
                      child: Text('Отменить'),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final suffixChild = isEmpty || widget.isHideClearTextBtn
        ? const SizedBox()
        : _buildClearIcon();

    final hasText = widget.text == null || widget.text.isEmpty;
    final searchHint = widget.hint ?? 'Поиск';
    return InputDecoration(
      contentPadding: EdgeInsets.zero,
      filled: true,
      fillColor: _searchBackgroundColorTween.value,
      labelText: hasText ? searchHint : widget.text,
      hintText: searchHint,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      focusedBorder: _border,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _searchBackgroundColorTween.value),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      prefixIconConstraints: const BoxConstraints(
        maxWidth: 38.0,
        maxHeight: 36.0,
      ),
      suffixIconConstraints: const BoxConstraints(
        maxWidth: 38.0,
        maxHeight: 36.0,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 10.0),
        child: GestureDetector(
          onTapCancel: () {
            _searchAnimationController.reverse();
          },
          onTap: () {
            widget.onSearchPressed();
          },
          onTapDown: (details) {
            _searchAnimationController.forward();
          },
          onTapUp: (details) {
            _searchAnimationController.reverse();
          },
          child: Text('Поиск'),
        ),
      ),
      suffixIcon: suffixChild,
    );
  }

  Widget _buildClearIcon() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 10.0, right: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _clearText,
          child: const Icon(
            Icons.cancel,
            color: Colors.grey,
            size: 18.0,
          ),
        ),
      ),
    );
  }

  void _handleInput() {
    setState(() {
      final inputText = _controller.text;
      isEmpty = inputText.isEmpty;
      if (currentInputText != inputText) {
        widget.onSearchInput?.call(inputText);
        currentInputText = inputText;
      }
    });
  }

  void _clearText() {
    setState(() {
      isEmpty = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _controller.text = EMPTY_STRING,
      );
    });
  }

  void _handleCancelBtn() {
    widget.onCancelTap?.call();
    if (widget.isClearTextOnCancelBtn) {
      _clearText();
    }
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          setState(() {
            if (!widget.isShowAlwaysCancelButton) _focusNode.unfocus();
            needShowCancelBtn = false;
          });
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
