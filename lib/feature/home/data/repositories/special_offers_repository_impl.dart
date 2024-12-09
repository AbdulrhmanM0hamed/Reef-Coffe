import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/excptions.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';

import '../../domain/entities/special_offer.dart';
import '../../domain/repositories/special_offers_repository.dart';
import '../datasources/special_offers_remote_data_source.dart';

class SpecialOffersRepositoryImpl implements SpecialOffersRepository {
  final SpecialOffersRemoteDataSource remoteDataSource;

  SpecialOffersRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<SpecialOffer>>> getSpecialOffers() async {
    try {
      final remoteOffers = await remoteDataSource.getSpecialOffers();
      return Right(remoteOffers);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}

// import 'dart:convert';
// import 'package:dartz/dartz.dart';
// import 'package:hyper_market/core/error/sevcice_failure.dart';
// import 'package:hyper_market/core/services/local_storage/local_storage_service.dart';
// import 'package:hyper_market/feature/home/data/datasources/special_offers_remote_data_source.dart';
// import 'package:hyper_market/feature/home/domain/entities/special_offer.dart';
// import 'package:hyper_market/feature/home/domain/repositories/special_offers_repository.dart';

// class SpecialOffersRepositoryImpl implements SpecialOffersRepository {
//   final SpecialOffersRemoteDataSource remoteDataSource;
//   final LocalStorageService localStorageService;
//   static const String cacheKey = 'special_offers_cache';

//   SpecialOffersRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localStorageService,
//   });

//   @override
//   Future<Either<Failure, List<SpecialOffer>>> getSpecialOffers() async {
//     try {
//       // Try to get data from cache first
//       final cachedData = localStorageService.getData<String>(cacheKey);
//       if (cachedData != null) {
//         try {
//           final List<dynamic> decodedData = json.decode(cachedData);
//           final List<SpecialOffer> offers = decodedData
//               .map((item) => SpecialOffer.fromJson(item))
//               .toList();
//           return Right(offers);
//         } catch (e) {
//           // If cache is corrupted, remove it
//           await localStorageService.removeData(cacheKey);
//         }
//       }

//       // If no cache or cache error, fetch from remote
//       try {
//         final offers = await remoteDataSource.getSpecialOffers();
        
//         // Cache the new data
//         await localStorageService.saveData(
//           cacheKey,
//           json.encode(offers.map((e) => e.toJson()).toList()),
//         );

//         return Right(offers);
//       } catch (e) {
//         return Left(ServerFailure(
//           errMessage: 'فشل في تحميل العروض من السيرفر. برجاء التحقق من اتصال الإنترنت',
//         ));
//       }
//     } catch (e) {
//       return Left(ServerFailure(
//         errMessage: 'حدث خطأ غير متوقع. برجاء المحاولة مرة أخرى',
//       ));
//     }
//   }
// }

