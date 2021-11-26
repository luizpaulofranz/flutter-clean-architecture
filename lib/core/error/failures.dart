import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Failure extends Equatable {
  late List properties;

  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  Failure([List properties = const <dynamic>[]]);

  @override
  List get props => [properties];
}

// General failures
// ignore: must_be_immutable
class ServerFailure extends Failure {}

// ignore: must_be_immutable
class CacheFailure extends Failure {}
