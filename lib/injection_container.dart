import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:progress_soft_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:progress_soft_app/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:progress_soft_app/features/auth/data/data_sources/firebase_user_data_source.dart';
import 'package:progress_soft_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/check_auth_status_use_case.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/check_email_exists.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/get_saved_token_use_case.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/send_otp_use_case.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/update_user_use_case.dart';
import 'package:progress_soft_app/features/auth/domain/use_cases/verfiy_otp_use_case.dart';
import 'package:progress_soft_app/features/post/domain/use_cases/fetch_posts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/features/settings/data/data_sources/settings_fire_base_rource.dart';
import 'core/features/settings/data/repositories/settings_repository_impl.dart';
import 'core/features/settings/domain/repositories/settings_repository.dart';
import 'core/features/settings/domain/use_cases/fetch_countries_use_case.dart';
import 'core/features/settings/domain/use_cases/fetch_regexes_use_case.dart';
import 'core/features/settings/presentation/bloc/settings_bloc.dart';
import 'core/network/network_info.dart';
import 'features/auth/domain/repositories/auth_repositories.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/post/data/data_sources/post_local_data_source.dart';
import 'features/post/data/data_sources/post_remote_data_source.dart';
import 'features/post/data/repositories/post_repository_impl.dart';
import 'features/post/domain/repositories/post_repositories.dart';
import 'features/post/presentation/bloc/posts_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  ///!Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  ///!External
  final shredPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => shredPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  ///!Features
  //-------------------------- [Posts Feature]
  //Blocs
  sl.registerFactory(() => PostsBloc(fetchPostsUseCase: sl()));
  //Use Cases
  sl.registerLazySingleton(() => FetchPostsUseCase(sl()));
  //Repository
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl.call()));
  //Data Source
  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(sharedPreferences: sl()));

  //-------------------------- [Settings Feature]
  //Blocs
  sl.registerFactory(() =>
      SettingsBloc(fetchCountriesUseCase: sl(), fetchRegexesUseCase: sl()));
  //Use Cases
  sl.registerLazySingleton(() => FetchCountriesUseCase(sl()));
  sl.registerLazySingleton(() => FetchRegexesUseCase(sl()));
  //Repository
  sl.registerLazySingleton<SettingsRepository>(() =>
      SettingsRepositoryImpl(settingsFireBaseRource: sl(), networkInfo: sl()));
  //Data Source
  sl.registerLazySingleton<SettingsFireBaseSource>(
      () => FirebaseDataSourceImpl(fireStore: sl()));


  //-------------------------- [Auth Feature]
  //Blocs
  sl.registerFactory(() =>
      AuthBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  //Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedTokenUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckEmailExistsUseCase(sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerfiyOtpUseCase(sl()));
  //Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl(), sl()));
  //Data Source

  sl.registerSingleton(FirebaseAuthDatasource());
  sl.registerSingleton(AuthLocalDataSource());
  sl.registerSingleton(FirebaseUserDatasource());
}
