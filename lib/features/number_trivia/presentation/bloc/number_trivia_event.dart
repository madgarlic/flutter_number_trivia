// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class NumberTriviaConcreteNumberStarted extends NumberTriviaEvent {
  final String numberString; // string because value comes from UI

  /* 
  if we did this:

    int get number => int.parse(numberString);
 
  The code above is logic!!! It would go agains principles of
  clean atchitecture to do this here
  */

  const NumberTriviaConcreteNumberStarted(this.numberString);

  @override
  List<Object> get props => [...super.props, numberString];
}

class NumberTriviaRandomNumberStarted extends NumberTriviaEvent {}
