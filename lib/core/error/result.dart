import 'failures.dart';

/// Lightweight replacement for `Either`: use cases and repositories return
/// either a [Success] with data or a [FailureResult] carrying a [Failure].
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final Failure failure;
}
