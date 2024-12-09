import 'package:equatable/equatable.dart';
import '../../domain/entities/special_offer.dart';

abstract class SpecialOffersState extends Equatable {
  const SpecialOffersState();

  @override
  List<Object> get props => [];
}

class SpecialOffersInitial extends SpecialOffersState {}

class SpecialOffersLoading extends SpecialOffersState {}

class SpecialOffersLoaded extends SpecialOffersState {
  final List<SpecialOffer> offers;

  const SpecialOffersLoaded(this.offers);

  @override
  List<Object> get props => [offers];
}

class SpecialOffersError extends SpecialOffersState {
  final String message;

  const SpecialOffersError({required this.message});

  @override
  List<Object> get props => [message];
}
