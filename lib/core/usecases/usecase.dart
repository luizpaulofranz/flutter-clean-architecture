import 'package:clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// defines a global interface for all of our use_cases
// the generics here are: First, the success return type (we dont have de pass Failure type because it will always be the same)
// the second is the params passed to the call method, so, we will always have to pass something (it is defined here, in this interface)
// so, when we have an empty method, we should use that NoParams class
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
