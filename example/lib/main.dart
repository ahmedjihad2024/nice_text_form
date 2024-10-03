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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CountryCodeButton(
          initialSelection: 'eg',
          localization: const Locale('en', "us"),
          width: 30,
          height: 15,
          dialogWidth: 350,
          borderRadius: BorderRadius.circular(6),
      onSelectionChange: (data){
            print(data.countryName);
      },),
    ));
  }
}
