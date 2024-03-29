import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

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
                if (state is NumberTriviaInitial) {
                  return const MessageDisplay(message: 'Start searching!');
                } else if (state is NumberTriviaFailure) {
                  return MessageDisplay(message: state.message);
                } else if (state is NumberTriviaLoading) {
                  return const LoadingIndicator();
                } else if (state is NumberTriviaSuccess) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                } else {
                  return const MessageDisplay(message: 'Unknown bloc state!');
                }
              },
            ),
            const SizedBox(height: 20),
            const TriviaControls(),
          ]),
        ),
      ),
    );
  }
}
