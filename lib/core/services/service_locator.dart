import 'package:get_it/get_it.dart';
import 'package:hyper_market/core/services/supabase/supabase_initialize.dart';
import 'package:hyper_market/core/services/local_storage/local_storage_service.dart';
import 'package:hyper_market/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hyper_market/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signup/signup_cubit.dart';
import 'package:hyper_market/feature/categories/data/datasources/category_remote_data_source.dart';
import 'package:hyper_market/feature/categories/data/repositories/category_repository_impl.dart';
import 'package:hyper_market/feature/categories/domain/repositories/category_repository.dart';
import 'package:hyper_market/feature/products/data/datasources/product_remote_data_source.dart';
import 'package:hyper_market/feature/products/data/repositories/product_repository_impl.dart';
import 'package:hyper_market/feature/products/domain/repositories/product_repository.dart';
import 'package:hyper_market/feature/home/data/datasources/special_offers_remote_data_source.dart';
import 'package:hyper_market/feature/home/data/repositories/special_offers_repository_impl.dart';
import 'package:hyper_market/feature/home/domain/repositories/special_offers_repository.dart';
import 'package:hyper_market/feature/home/domain/usecases/get_special_offers.dart';
import 'package:hyper_market/feature/home/presentation/cubit/special_offers_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());
  getIt.registerLazySingleton<LocalStorageService>(() => LocalStorageService());

  // Categories
  getIt.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(getIt<SupabaseService>()),
  );

  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt<CategoryRemoteDataSource>()),
  );

  // Products
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt<SupabaseService>()),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductRemoteDataSource>()),
  );

  // Special Offers
  getIt.registerLazySingleton<SpecialOffersRemoteDataSource>(
    () => SpecialOffersRemoteDataSourceImpl(
      supabaseClient: getIt<SupabaseService>().client,
    ),
  );

  getIt.registerLazySingleton<SpecialOffersRepository>(
    () => SpecialOffersRepositoryImpl(
      remoteDataSource: getIt<SpecialOffersRemoteDataSource>(),
      //  localStorageService: getIt<LocalStorageService>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetSpecialOffersUseCase(getIt<SpecialOffersRepository>()),
  );

  getIt.registerFactory(
    () => SpecialOffersCubit(getIt<GetSpecialOffersUseCase>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(() =>
      AuthRemoteDataSourceImpl(
          supabaseClient: getIt<SupabaseService>().client));

  getIt.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()));

  getIt.registerLazySingleton<SignInCubit>(
    () => SignInCubit(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignUpCubit>(
    () => SignUpCubit(authRepository: getIt<AuthRepository>()),
  );
}
