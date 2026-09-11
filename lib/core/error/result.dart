import 'failures.dart';

sealed class Result<S> {
  const Result();

  R fold<R>({
    required R Function(Failure failure) onError,
    required R Function(S value) onSuccess,
  }) {
    return switch (this) {
      Ok<S>(:final value) => onSuccess(value),
      Err<S>(:final failure) => onError(failure),
    };
  }

  bool get isOk => this is Ok<S>;
  bool get isErr => this is Err<S>;
}

final class Ok<S> extends Result<S> {
  final S value;
  const Ok(this.value);
}

final class Err<S> extends Result<S> {
  final Failure failure;
  const Err(this.failure);
}
