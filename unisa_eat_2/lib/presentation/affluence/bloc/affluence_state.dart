part of 'affluence_cubit.dart';

abstract class AffluenceState {}

class AffluenceInitial extends AffluenceState {}

class AffluenceLoading extends AffluenceState {}

class AffluenceLoaded extends AffluenceState {
  final AffluenceModel affluence;

  AffluenceLoaded(this.affluence);
}

class AffluenceError extends AffluenceState {
  final String error;

  AffluenceError(ApiError apiError) : error = apiError.type.toString();
}