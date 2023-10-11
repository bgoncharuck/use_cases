import 'package:flutter/widgets.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) => const Center(child: Text('test', textDirection: TextDirection.ltr));
}
