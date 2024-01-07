import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart';

void main() async {
  injectionSetUp();
  runApp(const NumberTriviaApp());
}

class NumberTriviaApp extends StatelessWidget {
  const NumberTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number trivia',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green.shade800,
          secondary: Colors.green.shade600,
          onSecondary: Colors.green.shade600,
        ),
      ),
      home: FutureBuilder(
          future: getIt.allReady(),
          builder: (context, snap) {
            if (snap.hasData) {
              return const NumberTriviaPage();
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Loading...'),
                ),
                body: const SafeArea(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          }),
    );
  }
}
