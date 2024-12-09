import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';

import '../entities/special_offer.dart';
import '../repositories/special_offers_repository.dart';

class GetSpecialOffersUseCase {
  final SpecialOffersRepository repository;

  GetSpecialOffersUseCase(this.repository);

  Future<Either<Failure, List<SpecialOffer>>> call() async {
    return await repository.getSpecialOffers();
  }
}
