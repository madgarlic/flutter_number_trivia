import 'package:flutter_number_trivia/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late InternetConnectionChecker mockDataconnectionChecker;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockDataconnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker: mockDataconnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionCheckerNulls.hasConnection',
        () async {
      // arrange
      final tHasConnectionFuture = Future.value(true);
      when(() => mockDataconnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      // act
      final result = networkInfo.isConnected;
      // assert
      verify(() => mockDataconnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
