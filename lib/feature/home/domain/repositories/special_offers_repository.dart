import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import '../entities/special_offer.dart';

abstract class SpecialOffersRepository {
  Future<Either<Failure,  List<SpecialOffer>>> getSpecialOffers();
}
