import 'package:hyper_market/core/error/excptions.dart';
import 'package:hyper_market/core/errors/network_error_handler.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/special_offer_model.dart';

abstract class SpecialOffersRemoteDataSource {
  Future<List<SpecialOfferModel>> getSpecialOffers();
}

class SpecialOffersRemoteDataSourceImpl
    implements SpecialOffersRemoteDataSource {
  final SupabaseClient supabaseClient;

  SpecialOffersRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<SpecialOfferModel>> getSpecialOffers() async {
    try {
      final response = await supabaseClient
          .from('special_offers')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((offer) => SpecialOfferModel.fromJson(offer))
          .toList();
    } catch (e) {
      throw CustomException(message: NetworkErrorHandler.getErrorMessage(e));
    }
  }
}
