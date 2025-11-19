import 'package:flutter/material.dart';
import 'package:nice_text_form/nice_text_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CountryCodePickerController controller = CountryCodePickerController(
      initialSelection: 'EG', locale: const Locale('en', "us"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CountryCodePicker(
              controller: controller,
              buttonWidth: 50,
              buttonHeight: 30,
              buttonBorderRadius: 6,
              onSelectionChange: (data) {
                print(data.countryName);
              },
            ),
            TextButton(
                onPressed: () {
                  controller.showSheet();
                },
                child: Text('Show Sheet')),
            TextButton(
                onPressed: () {
                  controller.hideSheet();
                },
                child: Text('Hide Sheet')),
            TextButton(
                onPressed: () {
                  controller.changeLocale(
                      controller.locale == const Locale('en', "us") ? const Locale('ar', "eg") : const Locale('en', "us"));
                },
                child: Text('Toggle Locale')),
            TextButton(
                onPressed: () {
                  controller.changeInitialSelection(
                      controller.initialSelection == 'EG' ? 'US' : 'EG');
                },
                child: Text('Toggle Initial Selection')),
          ],
        ),
      ),
    );
  }
}
