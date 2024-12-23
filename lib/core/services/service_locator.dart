import 'package:get_it/get_it.dart';
import 'package:hyper_market/core/services/notification_service.dart';
import 'package:hyper_market/core/services/supabase/supabase_initialize.dart';
import 'package:hyper_market/core/services/local_storage/local_storage_service.dart';
import 'package:hyper_market/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hyper_market/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signup/signup_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_cubit.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/categories/data/datasources/category_remote_data_source.dart';
import 'package:hyper_market/feature/categories/data/repositories/category_repository_impl.dart';
import 'package:hyper_market/feature/categories/domain/repositories/category_repository.dart';
import 'package:hyper_market/feature/details/data/repositories/comment_repository_impl.dart';
import 'package:hyper_market/feature/details/data/repositories/rating_repository_impl.dart';
import 'package:hyper_market/feature/details/domain/repositories/comment_repository.dart';
import 'package:hyper_market/feature/details/domain/repositories/rating_repository.dart';
import 'package:hyper_market/feature/details/domain/usecases/add_rating.dart';
import 'package:hyper_market/feature/details/domain/usecases/check_user_rating.dart';
import 'package:hyper_market/feature/details/domain/usecases/get_product_rating.dart';
import 'package:hyper_market/feature/details/domain/usecases/update_rating.dart';
import 'package:hyper_market/feature/details/presentation/cubit/comments_cubit.dart';
import 'package:hyper_market/feature/details/presentation/cubit/rating_cubit.dart';
import 'package:hyper_market/feature/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:hyper_market/feature/orders/data/datasources/order_remote_data_source.dart';
import 'package:hyper_market/feature/orders/data/repositories/order_repository_impl.dart';
import 'package:hyper_market/feature/orders/domain/repositories/order_repository.dart';
import 'package:hyper_market/feature/orders/domain/usecases/create_order_usecase.dart';
import 'package:hyper_market/feature/orders/domain/usecases/get_orders_usecase.dart';
import 'package:hyper_market/feature/orders/presentation/cubit/orders_cubit.dart';
import 'package:hyper_market/feature/products/data/datasources/product_remote_data_source.dart';
import 'package:hyper_market/feature/products/data/repositories/product_repository_impl.dart';
import 'package:hyper_market/feature/products/domain/repositories/product_repository.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';
import 'package:hyper_market/feature/home/data/datasources/special_offers_remote_data_source.dart';
import 'package:hyper_market/feature/home/data/repositories/special_offers_repository_impl.dart';
import 'package:hyper_market/feature/home/domain/repositories/special_offers_repository.dart';
import 'package:hyper_market/feature/home/domain/usecases/get_special_offers.dart';
import 'package:hyper_market/feature/home/presentation/cubit/special_offers_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());
  getIt.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());

  // Cart
  getIt.registerLazySingleton<CartCubit>(() => CartCubit());

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

  getIt.registerLazySingleton<ResetPasswordCubit>(
    () => ResetPasswordCubit(authRepository: getIt<AuthRepository>()),
  );

  // Favorites
  getIt.registerLazySingleton(() => FavoriteCubit());

  // Orders
  getIt.registerLazySingleton<OrdersCubit>(
    () => OrdersCubit(
      getOrdersUseCase: getIt<GetOrderUseCase>(),
      createOrderUseCase: getIt<CreateOrderUseCase>(),
    ),
  );

  getIt.registerLazySingleton(() => GetOrderUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton(
      () => CreateOrderUseCase(getIt<OrderRepository>()));

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: getIt<OrderRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(
      supabaseClient: getIt<SupabaseService>().client,
    ),
  );

  // Rating Feature
  getIt.registerFactory(
    () => RatingCubit(
      addRating: getIt<AddRatingUseCase>(),
      checkUserRating: getIt<CheckUserRatingUseCase>(),
      updateRating: getIt<UpdateRatingUseCase>(),
      getProductRating: getIt<GetProductRatingUseCase>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => AddRatingUseCase(getIt<RatingRepository>()));
  getIt.registerLazySingleton(() => CheckUserRatingUseCase(getIt<RatingRepository>()));
  getIt.registerLazySingleton(() => UpdateRatingUseCase(getIt<RatingRepository>()));
  getIt.registerLazySingleton(() => GetProductRatingUseCase(getIt<RatingRepository>()));

  // Repository
  getIt.registerLazySingleton<RatingRepository>(
    () => RatingRepositoryImpl(
      supabaseClient: Supabase.instance.client,
    ),
  );

  // Comment Dependencies
  getIt.registerLazySingleton(() => Supabase.instance.client);

  // Comment Dependencies
  getIt.registerLazySingleton(() => CommentCubit(commentRepository: getIt()));
  getIt.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(supabaseClient: getIt()),
  );

  // Product Dependencies
  getIt.registerLazySingleton(() => ProductsCubit(getIt<ProductRepository>()));

}
