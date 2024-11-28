
abstract class Failuer {
  final String errMessage;

  Failuer({required this.errMessage});
}

class ServerFailure extends Failuer {
  ServerFailure({required super.errMessage});


}
