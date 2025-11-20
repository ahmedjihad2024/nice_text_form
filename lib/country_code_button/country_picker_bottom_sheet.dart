import 'package:flutter/material.dart';
import 'package:nice_text_form/common/custom_ink_button.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../nice_text_form.dart';

class SheetSearchBarSettings {
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final BorderSide borderSide;
  final Color? backgroundColor;
  final Color? backgroundColorDark;
  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? hintStyleDark;
  final TextStyle? textStyle;
  final TextStyle? textStyleDark;
  const SheetSearchBarSettings(
      {this.height = 55,
      this.padding = const EdgeInsets.symmetric(horizontal: 15),
      this.borderRadius = const BorderRadius.all(Radius.circular(15)),
      this.borderSide = BorderSide.none,
      this.backgroundColor = const Color.fromARGB(255, 247, 247, 247),
      this.backgroundColorDark,
      this.hintText = "Search countries...",
      this.hintStyle = const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black38),
      this.hintStyleDark,
      this.textStyle = const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
      this.textStyleDark});
}

class SheetItemSettings {
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final BorderSide borderSide;
  final Color? backgroundColor;
  final Color? backgroundColorDark;
  final TextStyle? countryNameStyle;
  final TextStyle? countryNameStyleDark;
  final TextStyle? dialCodeStyle;
  final TextStyle? dialCodeStyleDark;
  final Color? splashColor;
  final Color? highlightColor;
  final BorderSide side;
  final double flagWidth;
  final double flagHeight;
  final BorderRadius flagBorderRadius;
  const SheetItemSettings(
      {this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      this.borderRadius = 10,
      this.borderSide = BorderSide.none,
      this.backgroundColor = const Color.fromARGB(255, 250, 250, 250),
      this.backgroundColorDark,
      this.countryNameStyle = const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      this.countryNameStyleDark,
      this.dialCodeStyle = const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
      this.dialCodeStyleDark,
      this.splashColor,
      this.highlightColor,
      this.side = BorderSide.none,
      this.flagWidth = 25,
      this.flagHeight = 25,
      this.flagBorderRadius = const BorderRadius.all(Radius.circular(99999))});
}

class CountryPickerBottomSheetSettings {
  final Color? sheetBackgroundColor;
  final Color? sheetBackgroundColorDark;
  final double sheetPaddingTop;
  final double sheetPaddingLeft;
  final double sheetPaddingRight;
  final double sheetPaddingBottom;
  final EdgeInsetsGeometry sheetMargin;
  final double sheetHeightPercentage;
  final BorderRadius sheetBorderRadius;
  final double smoothness;
  final BorderSide sheetBorderSide;
  final Color? sheetBarrierColor;
  final Color? sheetBarrierColorDark;
  final double sheetCloseWidth;
  final double sheetCloseHeight;
  final Color? sheetCloseIconColor;
  final Color? sheetCloseIconColorDark;
  final double sheetCloseIconSize;
  final BorderSide sheetCloseIconSide;
  final Color? sheetCloseIconBackgroundColor;
  final Color? sheetCloseIconBackgroundColorDark;
  final double sheetCloseIconBorderRadius;
  final Color? sheetCloseIconSplashColor;
  final Color? sheetCloseIconHighlightColor;
  final IconData sheetCloseIcon;
  final Color? darkModePrimaryColor;
  final SheetSearchBarSettings sheetSearchBarSettings;
  final SheetItemSettings sheetItemSettings;
  final bool isDarkMode;
  final bool enableScrollSpacingAnimation;
  final double minItemSpacing;
  final double maxItemSpacing;
  final Duration spacingAnimationDuration;

  const CountryPickerBottomSheetSettings(
      {this.sheetBackgroundColor = const Color(0xFFFFFFFF),
      this.sheetBackgroundColorDark,
      this.sheetPaddingTop = 20,
      this.sheetPaddingLeft = 15,
      this.sheetPaddingRight = 15,
      this.sheetPaddingBottom = 20,
      this.sheetMargin = EdgeInsets.zero,
      this.sheetHeightPercentage = 0.8,
      this.sheetBorderRadius = const BorderRadius.vertical(
        top: Radius.circular(25),
      ),
      this.smoothness = 1,
      this.sheetBorderSide = BorderSide.none,
      this.sheetBarrierColor,
      this.sheetBarrierColorDark,
      this.sheetSearchBarSettings = const SheetSearchBarSettings(),
      this.sheetItemSettings = const SheetItemSettings(),
      this.sheetCloseIconColor = Colors.black54,
      this.sheetCloseIconColorDark,
      this.sheetCloseIconSize = 15,
      this.sheetCloseIconSide = BorderSide.none,
      this.sheetCloseIconBackgroundColor =
          const Color.fromARGB(255, 240, 240, 240),
      this.sheetCloseIconBackgroundColorDark,
      this.sheetCloseIconBorderRadius = 15,
      this.sheetCloseIconSplashColor,
      this.sheetCloseIconHighlightColor,
      this.sheetCloseWidth = 30,
      this.sheetCloseHeight = 55,
      this.sheetCloseIcon = Icons.arrow_back_ios_new_rounded,
      this.darkModePrimaryColor,
      this.isDarkMode = false,
      this.enableScrollSpacingAnimation = true,
      this.minItemSpacing = 5.0,
      this.maxItemSpacing = 8.0,
      this.spacingAnimationDuration = const Duration(milliseconds: 200)});
}

class CountryPickerBottomSheet extends StatefulWidget {
  final CountryPickerBottomSheetSettings settings;
  final ValueNotifier<List<CountryCode>> countries;
  final ValueNotifier<CountryCode?> selectedCountryCode;
  final void Function(CountryCode) onSelectionChange;
  final TextEditingController searchController;
  const CountryPickerBottomSheet(
      {super.key,
      required this.settings,
      required this.countries,
      required this.selectedCountryCode,
      required this.onSelectionChange,
      required this.searchController});

  @override
  State<CountryPickerBottomSheet> createState() =>
      _CountryPickerBottomSheetState();

  static Future<void> show(BuildContext context,
      {CountryPickerBottomSheetSettings settings =
          const CountryPickerBottomSheetSettings(),
      required ValueNotifier<List<CountryCode>> countries,
      required ValueNotifier<CountryCode?> selectedCountryCode,
      required void Function(CountryCode) onSelectionChange,
      required TextEditingController searchController}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Colors.transparent,
      barrierColor: Theme.of(context).brightness == Brightness.dark
          ? (settings.sheetBarrierColorDark ??
              settings.sheetBarrierColor ??
              Colors.black87)
          : (settings.sheetBarrierColor ?? Colors.black54),
      context: context,
      builder: (context) => CountryPickerBottomSheet(
        settings: settings,
        countries: countries,
        selectedCountryCode: selectedCountryCode,
        onSelectionChange: onSelectionChange,
        searchController: searchController,
      ),
    );
  }
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  CountryPickerBottomSheetSettings get settings => widget.settings;
  late ScrollController _scrollController;
  double _currentSpacing = 5.0;
  bool _isScrolling = false;
  bool _isPointerDown = false;

  bool get _isDarkMode {
    return settings.isDarkMode;
  }

  Color _getColor(Color? lightColor, Color? darkColor, {Color? fallback}) {
    if (_isDarkMode) {
      return darkColor ?? fallback ?? lightColor ?? Colors.transparent;
    }
    return lightColor ?? fallback ?? Colors.transparent;
  }

  TextStyle _getTextStyle(TextStyle? lightStyle, TextStyle? darkStyle,
      {TextStyle? fallback}) {
    if (_isDarkMode) {
      return darkStyle ?? fallback ?? lightStyle ?? const TextStyle();
    }
    return lightStyle ?? fallback ?? const TextStyle();
  }

  @override
  void initState() {
    super.initState();
    _currentSpacing = settings.minItemSpacing;
    _scrollController = ScrollController();
    if (settings.enableScrollSpacingAnimation) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    if (settings.enableScrollSpacingAnimation) {
      _scrollController.removeListener(_onScroll);
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!settings.enableScrollSpacingAnimation) return;
    if (!_scrollController.hasClients) return;

    final isScrolling = _scrollController.position.isScrollingNotifier.value;
    
    if (isScrolling != _isScrolling) {
      setState(() {
        _isScrolling = isScrolling;
        _updateSpacing();
      });
    } else if (isScrolling) {
      // Keep spacing at max while scrolling and pointer is down
      _updateSpacing();
    }
  }

  void _updateSpacing() {
    if (!settings.enableScrollSpacingAnimation) return;
    
    // Increase spacing only when pointer is down and scrolling
    if (_isPointerDown && _isScrolling) {
      if (_currentSpacing != settings.maxItemSpacing) {
        setState(() {
          _currentSpacing = settings.maxItemSpacing;
        });
      }
    } else {
      // Decrease spacing when pointer is up or not scrolling
      if (_currentSpacing != settings.minItemSpacing) {
        setState(() {
          _currentSpacing = settings.minItemSpacing;
        });
      }
    }
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!settings.enableScrollSpacingAnimation) return;
    if (!_scrollController.hasClients) return;
    
    setState(() {
      _isPointerDown = true;
      // Check if already scrolling when pointer goes down
      _isScrolling = _scrollController.position.isScrollingNotifier.value;
      _updateSpacing();
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!settings.enableScrollSpacingAnimation) return;
    setState(() {
      _isPointerDown = false;
      // Immediately reset spacing when finger is removed
      _currentSpacing = settings.minItemSpacing;
    });
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (!settings.enableScrollSpacingAnimation) return;
    setState(() {
      _isPointerDown = false;
      // Immediately reset spacing when touch is cancelled
      _currentSpacing = settings.minItemSpacing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _isDarkMode
        ? (settings.darkModePrimaryColor ?? Theme.of(context).primaryColor)
        : Theme.of(context).primaryColor;
    return Container(
      width: double.infinity,
      height:
          MediaQuery.of(context).size.height * settings.sheetHeightPercentage,
      margin: settings.sheetMargin.add(
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          smoothness: settings.smoothness,
          borderRadius: settings.sheetBorderRadius,
          side: settings.sheetBorderSide,
        ),
        color: _getColor(
          settings.sheetBackgroundColor,
          settings.sheetBackgroundColorDark,
          fallback: _isDarkMode
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFFFFFFF),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: settings.sheetPaddingTop,
              left: settings.sheetPaddingLeft,
              right: settings.sheetPaddingRight,
            ),
            child: Row(
              children: [
                CustomInkButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  smoothness: settings.smoothness,
                  width: settings.sheetCloseWidth,
                  height: settings.sheetCloseHeight,
                  borderRadius: settings.sheetCloseIconBorderRadius,
                  backgroundColor: _getColor(
                    settings.sheetCloseIconBackgroundColor,
                    settings.sheetCloseIconBackgroundColorDark,
                    fallback: _isDarkMode
                        ? const Color.fromARGB(255, 40, 40, 40)
                        : const Color.fromARGB(255, 240, 240, 240),
                  ),
                  splashColor: settings.sheetCloseIconSplashColor ??
                      (_isDarkMode
                          ? primaryColor.withValues(alpha: 0.2)
                          : primaryColor.withValues(alpha: 0.1)),
                  highlightColor: settings.sheetCloseIconHighlightColor ??
                      (_isDarkMode
                          ? primaryColor.withValues(alpha: 0.1)
                          : primaryColor.withValues(alpha: 0.05)),
                  side: settings.sheetCloseIconSide,
                  child: Icon(
                    settings.sheetCloseIcon,
                    size: settings.sheetCloseIconSize,
                    color: _getColor(
                      settings.sheetCloseIconColor,
                      settings.sheetCloseIconColorDark,
                      fallback: _isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: settings.sheetSearchBarSettings.height,
                    alignment: Alignment.center,
                    padding: settings.sheetSearchBarSettings.padding,
                    decoration: ShapeDecoration(
                      color: _getColor(
                        settings.sheetSearchBarSettings.backgroundColor,
                        settings.sheetSearchBarSettings.backgroundColorDark,
                        fallback: _isDarkMode
                            ? const Color.fromARGB(255, 40, 40, 40)
                            : const Color.fromARGB(255, 247, 247, 247),
                      ),
                      shape: SmoothRectangleBorder(
                        smoothness: settings.smoothness,
                        borderRadius:
                            settings.sheetSearchBarSettings.borderRadius,
                        side: settings.sheetSearchBarSettings.borderSide,
                      ),
                    ),
                    child: TextField(
                      controller: widget.searchController,
                      style: _getTextStyle(
                        settings.sheetSearchBarSettings.textStyle,
                        settings.sheetSearchBarSettings.textStyleDark,
                        fallback: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: settings.sheetSearchBarSettings.hintText,
                        hintStyle: _getTextStyle(
                          settings.sheetSearchBarSettings.hintStyle,
                          settings.sheetSearchBarSettings.hintStyleDark,
                          fallback: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: _isDarkMode
                                ? Colors.white38
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.05, 0.95, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Listener(
                onPointerDown: settings.enableScrollSpacingAnimation
                    ? _onPointerDown
                    : null,
                onPointerUp: settings.enableScrollSpacingAnimation
                    ? _onPointerUp
                    : null,
                onPointerCancel: settings.enableScrollSpacingAnimation
                    ? _onPointerCancel
                    : null,
                child: ValueListenableBuilder(
                    valueListenable: widget.countries,
                    builder: (context, countryGroup, _) {
                      return ListView.separated(
                      controller: _scrollController,
                      itemCount: countryGroup.length,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: settings.sheetPaddingBottom +
                            MediaQuery.of(context).padding.bottom,
                        left: settings.sheetPaddingLeft,
                        right: settings.sheetPaddingRight,
                      ),
                      separatorBuilder: (context, index) =>
                          AnimatedContainer(
                        duration: settings.spacingAnimationDuration,
                        curve: Curves.easeOut,
                        height: settings.enableScrollSpacingAnimation
                            ? _currentSpacing
                            : settings.minItemSpacing,
                      ),
                      itemBuilder: (context, index) {
                        var countryData = countryGroup[index];

                        return CustomInkButton(
                          onTap: () {
                            widget.selectedCountryCode.value = countryData;
                            widget.onSelectionChange(countryData);
                            Navigator.pop(context);
                          },
                          smoothness: settings.smoothness,
                          padding: settings.sheetItemSettings.padding,
                          borderRadius: settings.sheetItemSettings.borderRadius,
                          backgroundColor: _getColor(
                            settings.sheetItemSettings.backgroundColor,
                            settings.sheetItemSettings.backgroundColorDark,
                            fallback: _isDarkMode
                                ? const Color.fromARGB(255, 35, 35, 35)
                                : const Color.fromARGB(255, 250, 250, 250),
                          ),
                          splashColor: settings.sheetItemSettings.splashColor ??
                              (_isDarkMode
                                  ? primaryColor.withValues(alpha: 0.2)
                                  : primaryColor.withValues(alpha: 0.1)),
                          highlightColor:
                              settings.sheetItemSettings.highlightColor ??
                                  (_isDarkMode
                                      ? primaryColor.withValues(alpha: 0.1)
                                      : primaryColor.withValues(alpha: 0.05)),
                          side: settings.sheetItemSettings.side,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                countryData.countryName,
                                overflow: TextOverflow.visible,
                                style: _getTextStyle(
                                  settings.sheetItemSettings.countryNameStyle,
                                  settings.sheetItemSettings.countryNameStyleDark,
                                  fallback: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                countryData.dialCode,
                                style: _getTextStyle(
                                  settings.sheetItemSettings.dialCodeStyle,
                                  settings.sheetItemSettings.dialCodeStyleDark,
                                  fallback: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SmoothClipRRect(
                                smoothness: settings.smoothness,
                                borderRadius:
                                    settings.sheetItemSettings.flagBorderRadius,
                                child: Image.asset(
                                  "packages/nice_text_form/${countryData.image}",
                                  fit: BoxFit.cover,
                                  width: settings.sheetItemSettings.flagWidth,
                                  height: settings.sheetItemSettings.flagHeight,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
