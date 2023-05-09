import 'package:flutter/material.dart';
import 'package:free_rishtey_wala/presentation/app/country_state_city_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  TextEditingController cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectStateData(),
    );
  }
}

