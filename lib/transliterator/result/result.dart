part of transliterator;

typedef ResultReducer<E> = E Function(E a, E b);

abstract class Result<E, S extends Language, T extends Language> {
  final E source;

  const Result(this.source);

  factory Result.fromIterable(E source, Iterable<E> targets) {
    switch (targets.length) {
      case 0:
        return EmptyResult<E, S, T>(source);
      case 1:
        return ResultPair<E, S, T>(source, targets.first);
      default:
        return ResultSet<E, S, T>.fromIterable(source, targets);
    }
  }

  /// Uses the provided [caster] function to convert the [source] and [target](s) of this [Result], and then returns a new [Result] of the same subtype as this one, using the converted values.
  Result<F, S, T> cast<F>(F Function(E e) caster) {
    if (this is EmptyResult) {
      return EmptyResult<F, S, T>(caster(source));
    } else if (this is ResultPair) {
      return ResultPair<F, S, T>(caster(source), caster((this as ResultPair<E, S, T>).target));
    } else if (this is ResultSet) {
      return ResultSet<F, S, T>(caster(source), LinkedHashSet<F>.of((this as ResultSet<E, S, T>).target.map(caster)));
    } else {
      throw TypeError();
    }
  }

  /// Joins an Iterable of [results] into a single Result. The returned [Result] will have [source] and [target] values calculated by running the sources/targets of each Result in the Iterable through the [sourceReducer]/[targetReducer] functions.
  static Result<E, S, T> join<E, S extends Language, T extends Language>(Iterable<Result<E, S, T>> results,
          {required ResultReducer<E> sourceReducer, required ResultReducer<E> targetReducer}) =>
      results.reduce((Result<E, S, T> a, Result<E, S, T> b) => joinPair(a, b, sourceReducer: sourceReducer, targetReducer: targetReducer));

  /// Takes two Results and returns a new Result. The `source` of the new Result will be given by passing the two input Results' `source`s into the `sourceReducer` function. All possible pairings of the two input Results' `target`s will be passed into the `targetReducer` function and used to build the `target` of the new Result. For input Results containing m and n elements in their `targets`, the output Result will have a target consisting of m*n elements. The concrete type of the Result returned will match the number of elements in its target.
  static Result<E, S, T> joinPair<E, S extends Language, T extends Language>(Result<E, S, T> a, Result<E, S, T> b,
      {required ResultReducer<E> sourceReducer, required ResultReducer<E> targetReducer}) {
    final E newSource = sourceReducer(a.source, b.source);
    final Iterable<E> aTargets;
    final Iterable<E> bTargets;

    if (a is ResultPair) {
      aTargets = <E>[(a as ResultPair<E, S, T>).target];
    } else if (a is ResultSet) {
      aTargets = (a as ResultSet<E, S, T>).target;
    } else {
      aTargets = Iterable<E>.empty();
    }

    if (b is ResultPair) {
      bTargets = <E>[(b as ResultPair<E, S, T>).target];
    } else if (b is ResultSet) {
      bTargets = (b as ResultSet<E, S, T>).target;
    } else {
      bTargets = Iterable<E>.empty();
    }

    final Iterable<E> newTarget = aTargets
        .map((E aTarget) => bTargets // For each target in `a`...
            .map((E bTarget) => targetReducer(aTarget, bTarget))) // ...turn it into an Iterable of all the ways targets in b can be added to it
        .expand((Iterable<E> target) => target); // ...and then flatten into a single iterable containing all the options.

    return Result<E, S, T>.fromIterable(newSource, newTarget);
  }
}
