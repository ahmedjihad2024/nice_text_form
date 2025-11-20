part of '../nice_text_form.dart';

class CountryCodeButton extends StatefulWidget {
  final String initialSelection;
  final Locale? localization;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? splashColor;
  final Color dialogBarrierColor;
  final BoxDecoration? dialogBoxDecoration;
  final double dialogWidth;
  final double dialogHeight;
  final EdgeInsets? dialogPadding;
  final bool dialogBarrierDismissible;
  final double dialogFlagWidth;
  final EdgeInsets? dialogSelectionsPadding;
  final Widget Function(Function() closeFunction, CountryCode)?
      dialogSelectionBuilder;
  final Widget Function(Function() closeFunction)? dialogCloseIconBuilder;
  final Widget Function(CountryCode)? buttonChildBuilder;
  final Widget Function(TextEditingController)? searchFormBuilder;
  final void Function(CountryCode) onSelectionChange;

  const CountryCodeButton(
      {super.key,
      required this.initialSelection,
      required this.onSelectionChange,
      this.localization,
      this.buttonChildBuilder,
      this.borderRadius,
      this.width,
      this.height,
      this.padding,
      this.splashColor,
      this.dialogBarrierColor = Colors.black12,
      this.dialogBoxDecoration,
      this.dialogHeight = 450,
      this.dialogWidth = 300,
      this.dialogPadding,
      this.dialogBarrierDismissible = true,
      this.searchFormBuilder,
      this.dialogCloseIconBuilder,
      this.dialogFlagWidth = 30,
      this.dialogSelectionsPadding,
      this.dialogSelectionBuilder});

  @override
  State<CountryCodeButton> createState() => _CountryCodeButtonState();
}

class _CountryCodeButtonState extends State<CountryCodeButton> {
  late CountryLocalization countryLocalization;
  CountryCode? selectedCountryCode;
  final List<CountryCode> countryCodeGroup = [];
  TextEditingController textEditingController = TextEditingController();
  ValueNotifier<List<CountryCode>> filteredCountryCodeGroup = ValueNotifier([]);

  Future<void> initLocalization() async {
    countryLocalization = CountryLocalization(widget.localization);
    await countryLocalization.load();
    selectedCountryCode =
        countryLocalization.getCountryCodeDetails(widget.initialSelection);
    widget.onSelectionChange(selectedCountryCode!);

    List<CountryCode> loadedCountryCodes =
        await compute(_loadCountryCodes, {'localization': countryLocalization});

    setState(() {
      countryCodeGroup.addAll(loadedCountryCodes);
      filteredCountryCodeGroup.value = List.from(countryCodeGroup);
    });
  }

  static List<CountryCode> _loadCountryCodes(Map<String, dynamic> params) {
    CountryLocalization localization = params['localization'];
    List<CountryCode> countryCodes = [];

    for (Map<String, String> countryData in codes) {
      String? localizedName =
          localization.countryNameGroup?[countryData['code']!];

      if (localizedName != null && localizedName.contains(',')) {
        localizedName = localizedName.split(',')[0];
      }

      String countryName = localization.isLocalized
          ? localizedName ?? countryData["name"]!
          : countryData["name"]!;

      countryCodes.add(CountryCode(
          countryData["code"]!,
          "assets/flags/${countryData['code']!.toLowerCase()}.png",
          countryData["dial_code"]!,
          countryName));
    }
    return countryCodes;
  }

  @override
  void initState() {
    initLocalization();
    super.initState();
    textEditingController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    textEditingController.removeListener(_filterCountries);
    textEditingController.dispose();
    filteredCountryCodeGroup.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = textEditingController.text.toLowerCase();
    filteredCountryCodeGroup.value = countryCodeGroup.where((country) {
      return country.countryName.toLowerCase().contains(query) ||
          country.dialCode.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showCountryDialog(),
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      hoverColor: widget.splashColor,
      child: Container(
        width: widget.width,
        height: widget.height,
        clipBehavior: Clip.hardEdge,
        padding: widget.padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(borderRadius: widget.borderRadius),
        child: selectedCountryCode != null
            ? widget.buttonChildBuilder != null
                ? widget.buttonChildBuilder!(selectedCountryCode!)
                : Image.asset(
                    "packages/nice_text_form/${selectedCountryCode!.image}",
                    fit: BoxFit.cover,
                  )
            : const SizedBox.shrink(),
      ),
    );
  }

  void showCountryDialog() {
    showDialog(
        context: context,
        barrierColor: widget.dialogBarrierColor,
        barrierDismissible: widget.dialogBarrierDismissible,
        builder: (dialogContext) {
          return Center(
            child: Container(
              width: widget.dialogWidth,
              height: widget.dialogHeight,
              padding: widget.dialogPadding ?? const EdgeInsets.all(20),
              decoration: widget.dialogBoxDecoration ??
                  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dialog close icon
                  if (widget.dialogCloseIconBuilder != null)
                    widget.dialogCloseIconBuilder!(
                        () => Navigator.pop(dialogContext))
                  else
                    IconButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close_rounded)),

                  // Search form
                  if (widget.searchFormBuilder != null)
                    widget.searchFormBuilder!(textEditingController)
                  else ...[
                    Material(
                      child: TextFormField(
                        controller: textEditingController,
                        decoration: const InputDecoration(hintText: "Search"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],

                  // Selections
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: filteredCountryCodeGroup,
                        builder: (context, countryGroup, _) {
                          return ListView.builder(
                            itemCount: countryGroup.length,
                            itemBuilder: (context, index) {
                              var countryData = countryGroup[index];

                              onPress() {
                                setState(() {
                                  selectedCountryCode = countryData;
                                });
                                widget.onSelectionChange(selectedCountryCode!);
                                Navigator.pop(dialogContext);
                              }

                              if (widget.dialogSelectionBuilder != null) {
                                return widget.dialogSelectionBuilder!(
                                    onPress, countryData);
                              }

                              return MaterialButton(
                                padding: widget.dialogSelectionsPadding,
                                onPressed: onPress,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      countryData.countryName,
                                      overflow: TextOverflow.visible,
                                    )),
                                    const Spacer(),
                                    Text(countryData.dialCode),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      "packages/nice_text_form/${countryData.image}",
                                      fit: BoxFit.contain,
                                      width: widget.dialogFlagWidth,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}

/// --------------------------------
///

class CountryCodePickerController {
  String initialSelection;
  Locale locale;
  bool _isSheetOpen = false;
  bool get isSheetOpen => _isSheetOpen;
  final void Function(CountryCode)? onSelectionChange;

  late Future<void> Function() _setLocale;
  late void Function() _setInitialSelection;
  late Future<void> Function() _showSheet;
  late void Function() _hideSheet;
  CountryCodePickerController(
      {required this.initialSelection,
      required this.locale,
      this.onSelectionChange});

  Future<void> changeLocale(Locale locale) async {
    this.locale = locale;
    await _setLocale();
  }

  void changeInitialSelection(String initialSelection) async {
    this.initialSelection = initialSelection;
    _setInitialSelection();
  }

  Future<void> showSheet() async {
    await _showSheet();
  }

  void hideSheet() async {
    _hideSheet();
  }

  void _setLocaleFunction(Future<void> Function() setLocale) {
    _setLocale = setLocale;
  }

  void _setInitialSelectionFunction(void Function() setInitialSelection) {
    _setInitialSelection = setInitialSelection;
  }

  void _setIsSheetOpenFunction(bool isSheetOpen) {
    _isSheetOpen = isSheetOpen;
  }

  void _setShowSheetFunction(Future<void> Function() showSheet) {
    _showSheet = showSheet;
  }

  void _setHideSheetFunction(void Function() hideSheet) {
    _hideSheet = hideSheet;
  }
}

class CountryCodePicker extends StatefulWidget {
  final CountryCodePickerController controller;
  final double buttonWidth;
  final double buttonHeight;
  final double buttonBorderRadius;
  final EdgeInsets buttonPadding;
  final Color buttonBackgroundColor;
  final Color buttonSplashColor;
  final Color buttonHighlightColor;
  final Color buttonShadowColor;
  final double buttonElevation;
  final double smoothness;
  final BorderSide buttonSide;
  final Function(CountryCode countryCode)? buttonBuilder;
  final void Function(CountryCode)? onSelectionChange;
  final CountryPickerBottomSheetSettings bottomSheetSettings;
  const CountryCodePicker({
    super.key,
    required this.controller,
    this.buttonBuilder,
    this.buttonWidth = 30,
    this.buttonHeight = 15,
    this.buttonBorderRadius = 12,
    this.buttonPadding = EdgeInsets.zero,
    this.buttonBackgroundColor = Colors.transparent,
    this.buttonSplashColor = Colors.transparent,
    this.buttonHighlightColor = Colors.transparent,
    this.buttonShadowColor = Colors.transparent,
    this.buttonElevation = 0,
    this.smoothness = 1,
    this.buttonSide = BorderSide.none,
    this.onSelectionChange,
    this.bottomSheetSettings = const CountryPickerBottomSheetSettings(),
  });
  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  late CountryLocalization countryLocalization;
  ValueNotifier<CountryCode?> selectedCountryCode = ValueNotifier(null);
  List<CountryCode> countryCodeGroup = [];
  TextEditingController textEditingController = TextEditingController();
  ValueNotifier<List<CountryCode>> filteredCountryCodeGroup = ValueNotifier([]);

  Future<void> initLocalization() async {
    countryLocalization = CountryLocalization(widget.controller.locale);
    await countryLocalization.load();
    selectedCountryCode.value = countryLocalization
        .getCountryCodeDetails(widget.controller.initialSelection);
    // widget.onSelectionChange(selectedCountryCode!);

    List<CountryCode> loadedCountryCodes =
        await compute(_loadCountryCodes, {'localization': countryLocalization});

    setState(() {
      countryCodeGroup = loadedCountryCodes;
      filteredCountryCodeGroup.value = List.from(countryCodeGroup);
    });
  }

  static List<CountryCode> _loadCountryCodes(Map<String, dynamic> params) {
    CountryLocalization localization = params['localization'];
    List<CountryCode> countryCodes = [];

    for (Map<String, String> countryData in codes) {
      String? localizedName =
          localization.countryNameGroup?[countryData['code']!];

      if (localizedName != null && localizedName.contains(',')) {
        localizedName = localizedName.split(',')[0];
      }

      String countryName = localization.isLocalized
          ? localizedName ?? countryData["name"]!
          : countryData["name"]!;

      countryCodes.add(CountryCode(
          countryData["code"]!,
          "assets/flags/${countryData['code']!.toLowerCase()}.png",
          countryData["dial_code"]!,
          countryName));
    }
    return countryCodes;
  }

  @override
  void initState() {
    initLocalization();
    super.initState();
    textEditingController.addListener(_filterCountries);
    widget.controller._setLocaleFunction(initLocalization);
    widget.controller._setInitialSelectionFunction(() {
      if (mounted) {
        setState(() {
          selectedCountryCode.value = countryLocalization
              .getCountryCodeDetails(widget.controller.initialSelection);
        });
      }
    });
    widget.controller._setShowSheetFunction(showSheet);
    widget.controller._setHideSheetFunction(() {
      if (mounted) {
        widget.controller._setIsSheetOpenFunction(false);
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    textEditingController.removeListener(_filterCountries);
    textEditingController.dispose();
    filteredCountryCodeGroup.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = textEditingController.text.toLowerCase();
    filteredCountryCodeGroup.value = countryCodeGroup.where((country) {
      return country.countryName.toLowerCase().contains(query) ||
          country.dialCode.contains(query);
    }).toList();
  }

  Future<void> showSheet() async {
    widget.controller._setIsSheetOpenFunction(true);
    await CountryPickerBottomSheet.show(context,
    settings: widget.bottomSheetSettings,
        countries: filteredCountryCodeGroup,
        selectedCountryCode: selectedCountryCode,
        onSelectionChange: (countryCode) {
      selectedCountryCode.value = countryCode;
      widget.onSelectionChange?.call(countryCode);
      widget.controller.onSelectionChange?.call(countryCode);
    }, searchController: textEditingController);
    widget.controller._setIsSheetOpenFunction(false);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedCountryCode,
        builder: (context, selectedCountryCodeValue, child) {
          return CustomInkButton(
            onTap: showSheet,
            backgroundColor: widget.buttonBackgroundColor,
            borderRadius: widget.buttonBorderRadius,
            padding: widget.buttonPadding,
            width: widget.buttonWidth,
            height: widget.buttonHeight,
            smoothness: widget.smoothness,
            side: widget.buttonSide,
            splashColor: widget.buttonSplashColor,
            highlightColor: widget.buttonHighlightColor,
            shadowColor: widget.buttonShadowColor,
            elevation: widget.buttonElevation,
            child: selectedCountryCodeValue != null
                ? widget.buttonBuilder?.call(selectedCountryCodeValue) ??
                    Image.asset(
                      "packages/nice_text_form/${selectedCountryCodeValue.image}",
                      fit: BoxFit.cover,
                    )
                : const SizedBox.shrink(),
          );
        });
  }
}
