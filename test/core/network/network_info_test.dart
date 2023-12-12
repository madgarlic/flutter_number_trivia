import 'package:flutter_number_trivia/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  late DataConnectionChecker mockDataconnectionChecker;
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
