import 'package:clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

// ignore: must_be_immutable
class InvalidInputFailure extends Failure { 

  @override
  final List props;
  InvalidInputFailure({this.props= const []}):super(props);
}
