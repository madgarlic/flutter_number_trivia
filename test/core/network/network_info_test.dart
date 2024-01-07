import 'package:flutter_number_trivia/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock implements InternetConnection {}

void main() {
  late InternetConnection mockDataconnectionChecker;
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
      when(() => mockDataconnectionChecker.hasInternetAccess)
          .thenAnswer((_) => tHasConnectionFuture);
      // act
      final result = networkInfo.isConnected;
      // assert
      verify(() => mockDataconnectionChecker.hasInternetAccess);
      expect(result, tHasConnectionFuture);
    });
  });
}
