import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/number_trivia_bloc.dart';
import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number trivia'),
      ),
      body: SafeArea(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            const SizedBox(height: 10),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                return Expanded(
                  child: Placeholder(
                    fallbackHeight: MediaQuery.of(context).size.height / 3,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Column(
              children: [
                Placeholder(fallbackHeight: 40),
                SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      child: Placeholder(
                    fallbackHeight: 40,
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Placeholder(
                    fallbackHeight: 40,
                  )),
                ]),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
