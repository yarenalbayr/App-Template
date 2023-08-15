import 'package:dartz/dartz.dart';

extension EitherExtension<L, R> on Either<L, R> {
  R get asRightResult => (this as Right<L, R>).value;
  L get asLeftResult => (this as Left<L, R>).value;

  bool get isRightAndNotNull => isRight() && asRightResult != null;
  bool get isLeftAndNotNull => isLeft() && asLeftResult != null;

  /// Will return the right value is it is right. Null otherwise (left)
  R? get asRightOrNull => isRight() ? asRightResult : null;

  /// Will return the left value is it is left. Null otherwise (right)
  L? get asLeftOrNull => isLeft() ? asLeftResult : null;

  Either<L, T> asLeft<T>() => left(asLeftResult);
  Either<T, R> asRight<T>() => right(asRightResult);

  Either<L, T> castRight<T>(T Function(R value) castFunc) =>
      fold(left, (r) => right(castFunc(r)));

  Either<L, T> castRightList<T>(T Function(R value) castFunc) =>
      fold(left, (r) => right(castFunc(r)));
}

extension EitherCast<T> on T {
  Either<R, T> toRight<R>() => right(this);
  Either<T, R> toLeft<R>() => left(this);
}
