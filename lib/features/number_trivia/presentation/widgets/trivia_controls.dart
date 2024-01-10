import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late String inputString;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: (text) {
            inputString = text;
          },
          onSubmitted: (_) => addConcreteEvent(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: ElevatedButton(
              onPressed: addConcreteEvent,
              child: const Text('Search'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: addRandomEvent,
              child: const Text('Get random'),
            ),
          ),
        ]),
      ],
    );
  }

  addConcreteEvent() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(NumberTriviaConcreteNumberStarted(inputString));
    inputString = '';
  }

  addRandomEvent() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(NumberTriviaRandomNumberStarted());
    inputString = '';
  }
}
