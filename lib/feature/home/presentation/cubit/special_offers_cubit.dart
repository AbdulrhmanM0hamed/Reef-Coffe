import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_special_offers.dart';
import 'special_offers_state.dart';

class SpecialOffersCubit extends Cubit<SpecialOffersState> {
  final GetSpecialOffersUseCase getSpecialOffers;

  SpecialOffersCubit(this.getSpecialOffers) : super(SpecialOffersInitial());

  Future<void> loadSpecialOffers() async {
    emit(SpecialOffersLoading());
    final result = await getSpecialOffers();

    result.fold(
      (failure) => emit(SpecialOffersError(message: failure.message)),
      (offers) {
        if (!isClosed) emit(SpecialOffersLoaded(offers));
      },
    );
  }
}
