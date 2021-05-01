part of transliterator;

typedef Sub<U extends StringUnit> = Subunit<U>;
typedef AtomResult<U extends StringUnit, X, S extends Language, T extends Language> = Result<Atom<U, X>, S, T>;
typedef Trans<U extends StringUnit, S extends Language, T extends Language> = StringTransliterator<U, S, T>;
typedef SubTrans<U extends StringUnit, S extends Language, T extends Language> = StringTransliterator<Subunit<U>, S, T>;
typedef SubResult<U extends StringUnit, S extends Language, T extends Language> = Result<Subunit<U>, S, T>;
typedef SubAtom<U extends StringUnit, X> = Atom<Subunit<U>, X>;
typedef SubAtomResult<U extends StringUnit, X, S extends Language, T extends Language> = Result<Atom<Subunit<U>, X>, S, T>;
typedef Matrix<E> = List<List<E>>;

abstract class StringTransliterator<Unit extends StringUnit, S extends Language, T extends Language> extends Transliterator<Unit, S, T> {
  StringTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  Unit buildUnit(String string, {required bool isComplete});

  Unit sourceReducer(Unit a, Unit b) => buildUnit('$a$b', isComplete: b.isComplete);

  Unit targetReducer(Unit a, Unit b) => buildUnit('$a$b', isComplete: b.isComplete);

  @override
  Result<Unit, S, T> transliterate(Unit input, {bool useOutputWriter = false});

  @override
  Iterable<Result<Unit, S, T>> transliterateAll(Iterable<Unit> inputs, {bool useOutputWriter = false}) =>
      inputs.map((Unit input) => transliterate(input, useOutputWriter: useOutputWriter));
}

mixin SuperUnitStringTransliterator<U extends StringUnit, S extends Language, T extends Language> on StringTransliterator<U, S, T> {
  SubTrans<U, S, T> getSubtransliterator();

  Subunit<U> buildSubunit(String string, {required bool isComplete}) => getSubtransliterator().buildUnit(string, isComplete: isComplete);

  @override
  Result<U, S, T> transliterate(U input, {bool useOutputWriter = false}) => splitMapJoin(input);

  ///Splits the contents of the [input] into [Subunit<Unit>]s, transliterates those [Subunit<Unit>]s, and then joins the results back into a [U].
  Result<U, S, T> splitMapJoin(
    U input, {
    SubResult<U, S, T> Function(String nonMatch)? onNonMatch,
    SubResult<U, S, T> Function(Match match)? onMatch,
  }) {
    final SubTrans<U, S, T> subtransliterator = getSubtransliterator();
    onMatch ??= (Match match) => subtransliterator.transliterate(buildSubunit(match[0]!, isComplete: true));
    onNonMatch ??= (String nonMatch) => ResultPair<Subunit<U>, S, T>.fromValue(buildSubunit(nonMatch, isComplete: false));

    final Iterable<Match> matches = (input as Superunit<Subunit<U>>).splitIntoSubunits();
    int previousMatchEnd = 0;

    //if nothing matched, then treat the entire input as a nonMatch and return a corresponding Result.
    if (matches.isEmpty) {
      return onNonMatch(input.content).cast<U>((Subunit<U> subunit) => buildUnit(subunit.content, isComplete: false));
    }

    Iterable<SubResult<U, S, T>> results() sync* {
      for (final Match match in matches) {
        if (match.start > previousMatchEnd) {
          yield onNonMatch!(input.content.substring(previousMatchEnd, match.start));
        }
        yield onMatch!(match);
        previousMatchEnd = match.end;
      }

      if (previousMatchEnd < input.content.length) {
        yield onNonMatch!(input.content.substring(previousMatchEnd, input.content.length));
      }
    }

    return (Result.join<Subunit<U>, S, T>(
      results(),
      sourceReducer: subtransliterator.sourceReducer,
      targetReducer: subtransliterator.targetReducer,
    )).cast<U>((Subunit<U> subunit) => subunit.cast<U>());
  }

  // TODO: The type constraint on this is weaker than it should be. Ideally it'd accept List<Atom<Unit, X>>, but if it gets passed something of type Subunit<E> where E is the superunit of Unit, it won't accept those as being the same. The weaker type restriction is a work around until I figure out a better solution. Additionally the Superunit<Subunit<Unit>> casts are hacks because `splitIntoSubunits` is only defined on Superunits and I lack the ability to properly add the constraint that asserts that Unit is a Superunit
  /// Takes a [List] of [Atom]s whose contents collectively represent one [StringUnit]'s content, and returns the results of transliteration on them.
  Iterable<AtomResult<U, X, S, T>?> transliterateAtoms<X>(List<Atom<StringUnit, X>?> unitAtoms) {
    final SubTrans<U, S, T> subtransliterator = getSubtransliterator();

    // If the subtransliterator of this transliterator is a superunit, then we will recurse down into its transliterateAtoms method.
    if (subtransliterator is SuperUnitStringTransliterator<Subunit<U>, S, T>) {
      final Matrix<SubAtom<U, X>?> subunitUnitMatrix = _breakUnitAtomsIntoSubunitUnitMatrix<X>(unitAtoms);
      final Matrix<SubAtomResult<U, X, S, T>?> transliteratedUnitSubunitAtomMatrix = _transliterateSubunitUnitMatrix<X>(subunitUnitMatrix, subtransliterator);
      final List<AtomResult<U, X, S, T>?> unitAtomResults =
          _joinTransliteratedSubunitResultAtomsIntoUnitResultAtoms<X>(transliteratedUnitSubunitAtomMatrix, subtransliterator);

      return unitAtomResults;
    }

    // But if we're at the lowest level of unit, and if so, just call the basic transliterate() method.
    else {
      return unitAtoms.map<AtomResult<U, X, S, T>?>(
        (Atom<StringUnit, X>? unitAtom) =>
            unitAtom != null ? splitMapJoin(unitAtom.content as U).cast<Atom<U, X>>((StringUnit unit) => Atom<U, X>(unit as U, unitAtom.context)) : null,
      );
    }
  }

  /// Decomposes [unitAtoms], which is a [List] o f [Atom]s whose contents collectively represent one [StringUnit]'s content into a matrix of [Subunit<StringUnit>] Atoms. The element `matrix[i][j]` represents the part of the ith Subunit in the collective StringUnit whose contents are located in the jth Atom of the the collective StringUnit.
  Matrix<SubAtom<U, X>?> _breakUnitAtomsIntoSubunitUnitMatrix<X>(List<Atom<StringUnit, X>?> unitAtoms) {
    final Matrix<SubAtom<U, X>?> subunitUnitMatrix = <List<SubAtom<U, X>?>>[];
    int subunitNumber = 0;
    bool subunitIsComplete = true;
    for (int unitAtomNumber = 0; unitAtomNumber < unitAtoms.length; unitAtomNumber++) {
      if (unitAtoms[unitAtomNumber] == null) {
        continue;
      }
      final X unitAtomContext = unitAtoms[unitAtomNumber]!.context; // This context will get passed to all subAtoms created from this Atom.
      final List<Match> subunitMatches = (unitAtoms[unitAtomNumber]!.content as Superunit<Subunit<U>>).splitIntoSubunits().toList();
      final int subunitCount = subunitNumber + subunitMatches.length;

      //On a new unitAtom, we need to add new subunit rows to the matrix of length equal to the total atom count.
      subunitUnitMatrix.addAll(
        Iterable<List<SubAtom<U, X>?>>.generate(
          subunitIsComplete ? subunitMatches.length : subunitMatches.length - 1,
          (int i) => List<SubAtom<U, X>?>.filled(unitAtoms.length, null),
        ),
      );
      for (final Match subunitMatch in subunitMatches) {
        final String subunitContents = subunitMatch.group(0) ?? '';

        //Because we define as a constraint to the problem space that a subunit can not span multiple units (which is a distinct statement from saying that it can't span multiple unit atoms, which is allowed), we well consider a subunit as complete if it's the last subunit of the last atom for the unit. For example, the last bit of text in a paragraph will be considered a complete sentence even if it does not otherwise have punctuation indicating such. Additionally, any subunits which do not reach the end of this unit will always be complete, as that completeness is a requisite feature of what it means for them to be able to have been split in the first place.
        subunitIsComplete = subunitNumber < subunitCount - 1 ||
            unitAtomNumber == unitAtoms.length - 1 && subunitNumber == subunitCount - 1 ||
            StringUnit.matchesEndPattern(U, subunitContents);
        final SubAtom<U, X> subunitAtom = Atom<Subunit<U>, X>(buildSubunit(subunitContents, isComplete: subunitIsComplete), unitAtomContext);
        subunitUnitMatrix[subunitNumber][unitAtomNumber] = subunitAtom;
        // Some subunit end patterns have optional characters after the required ones. If a an atom break occurs somewhere after the required character, but before all of the optional characters, then the subunit will be considered to be broken prematurely. To avoid this, the content of the next unitAtom needs to be checked to see if it starts with any of the optional characters. If it does, then the following needs to occur:
        // 1) The subunitAtom we just made also needs to have its `isComplete` value changed to indicate that it wasn't quite done yet.
        // 2) Those characters need to be extracted from that atom and inserted into the matrix as part of _this_ subunit. They can not be left for the next atom to process, since it would have no way of knowing if those characters should belong to the previous atom instead.
        // 3) The next unitAtom's content then needs to be updated to no longer include those extracted characters so that it starts at the correct point.
        // Only run this special logic if this is the last subunit of the atom, there is another atom after it, and we identified the subunit as complete.
        if (subunitMatch == subunitMatches.last && unitAtomNumber < unitAtoms.length - 1 && subunitIsComplete) {
          //Calculate what this subunit's content would have been if we included the next unitAtom's content as well.
          final Atom<StringUnit, X> nextUnitAtom = unitAtoms[unitAtomNumber + 1]!;
          final String nextUnitAtomContent = nextUnitAtom.content.content;
          final String extendedSubunitContents = subunitContents + nextUnitAtomContent;
          final Iterable<Match> extendedSubunitMatches = (buildUnit(extendedSubunitContents, isComplete: true) as Superunit<Subunit<U>>).splitIntoSubunits();
          final Match firstExtendedSubunitMatch = extendedSubunitMatches.first;
          final int firstExtendedSubunitLength = firstExtendedSubunitMatch.end - firstExtendedSubunitMatch.start;
          // Test to see if this new alternative content would have differed from the original
          final int extraExtendedSubunitMatchCharacters = firstExtendedSubunitLength - subunitContents.length;
          if (extraExtendedSubunitMatchCharacters > 0) {
            // At this point, we've detected that the next UnitAtom contains a little bit more of this Subunit, so we need to do the necessary work to adjust for that.
            // 1) Fix old subunitAtom's isComplete value
            final SubAtom<U, X> revisedSubunitAtom = Atom<Subunit<U>, X>(buildSubunit(subunitContents, isComplete: false), unitAtomContext);
            subunitUnitMatrix[subunitNumber][unitAtomNumber] = revisedSubunitAtom;
            // 2) Add a SubAtom to the matrix for the extra bit of this Subunit in the next Atom.
            final SubAtom<U, X> extraSubunitAtom = Atom<Subunit<U>, X>(
              buildSubunit(nextUnitAtomContent.substring(0, extraExtendedSubunitMatchCharacters), isComplete: true),
              unitAtomContext,
            );
            subunitUnitMatrix[subunitNumber][unitAtomNumber + 1] = extraSubunitAtom;
            // 3) Removed those extracted characters from from the next UnitAtom's content.
            unitAtoms[unitAtomNumber + 1] = nextUnitAtom.withNewContent(StringUnit.build(
              U,
              nextUnitAtomContent.substring(extraExtendedSubunitMatchCharacters),
              isComplete: true,
            ));
          }
        }
        // Now that we are sure that we've reached the end of the subunit, we can move onto the next.
        if (subunitIsComplete) {
          subunitNumber++;
        }
      }
    }
    return subunitUnitMatrix;
  }

  /// Calls the appropriate [StringTransliterator] for to execute the transliteration of the [Subunit<StringUnit>] [Atom]s returned from [_breakUnitAtomsIntoSubunitUnitMatrix], once for each Subunit extracted from the original [StringUnit]'s Atoms. Returns a matrix of identical form to the [subunitUnitMatrix] passed in, except that the indices are transposed.
  Matrix<SubAtomResult<U, X, S, T>?> _transliterateSubunitUnitMatrix<X>(
    Matrix<SubAtom<U, X>?> subunitUnitMatrix,
    SuperUnitStringTransliterator<Subunit<U>, S, T> subtransliterator,
  ) {
    if (subunitUnitMatrix.isEmpty) {
      return <List<SubAtomResult<U, X, S, T>?>>[];
    }

    // Prebuild this matrix to be the transposed size of the sentenceParagraphAtomMatrix.
    final Matrix<SubAtomResult<U, X, S, T>?> transliteratedUnitSubunitAtomMatrix = List<List<SubAtomResult<U, X, S, T>?>>.of(
      Iterable<List<SubAtomResult<U, X, S, T>?>>.generate(
        subunitUnitMatrix.first.length,
        (int i) => List<SubAtomResult<U, X, S, T>?>.filled(subunitUnitMatrix.length, null),
      ),
    );

    //Send all the atoms for each subunit to the subunitTransliterator
    for (int subunitNumber = 0; subunitNumber < subunitUnitMatrix.length; subunitNumber++) {
      // A list of the subunit atoms which comprise the entire subunit, indexed by which unitAtom it came from.
      final List<SubAtom<U, X>?> subunitAtoms = subunitUnitMatrix[subunitNumber];
      if (subunitAtoms.isNotEmpty) {
        //A list of transliterated subunit atoms results which comprise the entire subunit, indexed by which unitAtom it came from.
        final List<SubAtomResult<U, X, S, T>?> transliteratedSubunitAtoms = subtransliterator.transliterateAtoms<X>(subunitAtoms).toList();
        for (int unitNumber = 0; unitNumber < transliteratedSubunitAtoms.length; unitNumber++) {
          transliteratedUnitSubunitAtomMatrix[unitNumber][subunitNumber] = transliteratedSubunitAtoms[unitNumber];
        }
      }
    }
    return transliteratedUnitSubunitAtomMatrix;
  }

  /// Recomposes the [transliteratedUnitSubunitAtomMatrix] into a [List] of [Result]s, with each Result containing the transliteration of an [Atom] of the original [StringUnit].
  List<AtomResult<U, X, S, T>?> _joinTransliteratedSubunitResultAtomsIntoUnitResultAtoms<X>(
    Matrix<SubAtomResult<U, X, S, T>?> transliteratedUnitSubunitAtomMatrix,
    SuperUnitStringTransliterator<Subunit<U>, S, T> subtransliterator,
  ) {
    SubAtom<U, X> atomSourceReducer(SubAtom<U, X> a, SubAtom<U, X> b) => a.withNewContent(subtransliterator.sourceReducer(a.content, b.content));
    SubAtom<U, X> atomTargetReducer(SubAtom<U, X> a, SubAtom<U, X> b) => a.withNewContent(subtransliterator.targetReducer(a.content, b.content));

    final List<AtomResult<U, X, S, T>?> unitAtomResults = <AtomResult<U, X, S, T>?>[];
    for (final List<SubAtomResult<U, X, S, T>?> unitSubunitAtomResults in transliteratedUnitSubunitAtomMatrix) {
      final Iterable<SubAtomResult<U, X, S, T>> nonNullUnitSubunitAtomResults = unitSubunitAtomResults.whereType<SubAtomResult<U, X, S, T>>();
      if (nonNullUnitSubunitAtomResults.isNotEmpty) {
        unitAtomResults.add(Result.join<SubAtom<U, X>, S, T>(
          nonNullUnitSubunitAtomResults,
          sourceReducer: atomSourceReducer,
          targetReducer: atomTargetReducer,
        ).cast<Atom<U, X>>((SubAtom<U, X> subunitAtom) => Atom<U, X>(subunitAtom.content.cast<U>(), subunitAtom.context)));
      }
    }

    return unitAtomResults;
  }
}
