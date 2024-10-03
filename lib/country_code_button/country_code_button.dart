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
          fit: BoxFit.fill,
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
                      }
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}