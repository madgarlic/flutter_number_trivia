import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

void injectionSetUp() {
  //! External
  getIt.registerSingletonAsync<SharedPreferences>(() async {
    final sp = await SharedPreferences.getInstance();
    return sp;
  });

  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnection());

  //! Core stuff

  getIt.registerLazySingleton(() => InputConverter());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: getIt()),
  );

  //! Features - Number Trivia

  // Bloc

  getIt.registerFactory<NumberTriviaBloc>(
    () => NumberTriviaBloc(
        concreteUseCase: getIt(),
        randomUseCase: getIt(),
        inputConverter: getIt()),
  );

  // Use cases

  getIt.registerLazySingleton(() => GetConcreteNumberTrivia(getIt()));
  getIt.registerLazySingleton(() => GetRandmoNumberTrivia(getIt()));

  // Repositories

  getIt.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            localDatasource: getIt(),
            remoteDatasource: getIt(),
            networkInfo: getIt(),
          ));

  // Data sources

  getIt.registerLazySingleton<NumberTriviaRemoteDatasource>(
      () => NumberTriviaRemoteDataSourceImpl(client: getIt()));
  getIt.registerSingletonWithDependencies<NumberTriviaLocalDatasource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: getIt()),
      dependsOn: [SharedPreferences]);
}
