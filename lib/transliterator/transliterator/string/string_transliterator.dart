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

  Unit buildUnit(String string);

  Unit sourceReducer(Unit a, Unit b) => buildUnit('$a$b');

  Unit targetReducer(Unit a, Unit b) => buildUnit('$a$b');

  @override
  Result<Unit, S, T> transliterate(Unit input, {bool useOutputWriter = false});

  @override
  Iterable<Result<Unit, S, T>> transliterateAll(Iterable<Unit> inputs, {bool useOutputWriter = false}) =>
      inputs.map((Unit input) => transliterate(input, useOutputWriter: useOutputWriter));
}

mixin SuperUnitStringTransliterator<U extends StringUnit, S extends Language, T extends Language> on StringTransliterator<U, S, T> {
  SubTrans<U, S, T> getSubtransliterator();

  Subunit<U> buildSubunit(String string) => getSubtransliterator().buildUnit(string);

  @override
  Result<U, S, T> transliterate(U input, {bool useOutputWriter = false}) => splitMapJoin(input);

  ///Splits the contents of the [input] into [Subunit<Unit>]s, transliterates those [Subunit<Unit>]s, and then joins the results back into a [U].
  Result<U, S, T> splitMapJoin(
    U input, {
    SubResult<U, S, T> Function(String nonMatch)? onNonMatch,
    SubResult<U, S, T> Function(Match match)? onMatch,
  }) {
    final SubTrans<U, S, T> subtransliterator = getSubtransliterator();
    onMatch ??= (Match match) => subtransliterator.transliterate(buildSubunit(match[0]!));
    onNonMatch ??= (String nonMatch) => ResultPair<Subunit<U>, S, T>.fromValue(buildSubunit(nonMatch));

    final Iterable<Match> matches = input.splitIntoSubunits();
    int previousMatchEnd = 0;

    //if nothing matched, then treat the entire input as a nonMatch and return a corresponding Result.
    if (matches.isEmpty) {
      return onNonMatch(input.content).cast<U>((Subunit<U> subunit) => buildUnit(subunit.content));
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

  // TODO: The type constraint on this is weaker than it should be. Ideally it'd accept List<Atom<Unit, X>>, but if it gets passed something of type Subunit<E> where E is the superunit of Unit, it won't accept those as being the same. The weaker type restriction is a work around until I figure out a better solution.
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

  /// Decomposes [unitAtoms], which is a [List] of [Atom]s whose contents collectively represent one [StringUnit]'s content into a matrix of [Subunit<StringUnit>] Atoms. The element `matrix[i][j]` represents the part of the ith Subunit in the collective StringUnit whose contents are located in the jth Atom of the the collective StringUnit.
  Matrix<SubAtom<U, X>?> _breakUnitAtomsIntoSubunitUnitMatrix<X>(List<Atom<StringUnit, X>?> unitAtoms) {
    final Matrix<SubAtom<U, X>?> subunitUnitMatrix = <List<SubAtom<U, X>?>>[];
    int subunitNumber = 0;
    for (int unitAtomNumber = 0; unitAtomNumber < unitAtoms.length; unitAtomNumber++) {
      if (unitAtoms[unitAtomNumber] == null) {
        continue;
      }
      final bool isLastUnitAtom = unitAtomNumber == unitAtoms.length - 1;
      final X unitAtomContext = unitAtoms[unitAtomNumber]!.context; // This context will get passed to all subAtoms created from this Atom.
      final List<Match> subunitMatches = unitAtoms[unitAtomNumber]!.content.splitIntoSubunits().toList();
      final Atom<StringUnit, X>? nextUnitAtom = isLastUnitAtom ? null : unitAtoms[unitAtomNumber + 1];
      final String nextUnitAtomContent = nextUnitAtom?.content.content ?? '';
      // Create an "extended unit" which is this unit combined with the next one.
      final String extendedUnitContent = unitAtoms[unitAtomNumber]!.content.content + nextUnitAtomContent;
      // And split that extended unit into subunits. These "extended subunits" can be used to see a subunit extends across the atom boundary, or the subunit ends at the same place as the unit does.
      final List<Match> extendedSubunitMatches = (buildUnit(extendedUnitContent)).splitIntoSubunits().toList();
      final int subunitCount = subunitNumber + subunitMatches.length;
      //On a new unitAtom, we need to add new subunit rows to the matrix of length equal to the total atom count.
      subunitUnitMatrix.addAll(
        Iterable<List<SubAtom<U, X>?>>.generate(
          subunitMatches.length,
          (int i) => List<SubAtom<U, X>?>.filled(unitAtoms.length, null),
        ),
      );
      for (int subunitMatchIndex = 0; subunitMatchIndex < subunitMatches.length; subunitMatchIndex++) {
        final bool isLastSubunit = subunitNumber == subunitCount - 1;
        final String subunitContent = subunitMatches[subunitMatchIndex].group(0) ?? '';
        // For the last subunit of an atom which is followed by a non-null atom, we need to figure out if the subunit is complete.
        if (isLastSubunit && nextUnitAtom != null) {
          //Calculate what this subunit's content would have been if we included the next unitAtom's content as well.
          final int extendedSubunitMatchLength = extendedSubunitMatches[subunitMatchIndex].end - extendedSubunitMatches[subunitMatchIndex].start;
          final int extraExtendedSubunitMatchCharacters = extendedSubunitMatchLength - subunitContent.length;
          // Test to see if this new alternative content would have differed from the original. If there is more to this subunit, and the next atom would complete it (which means the extended unit can be split more than the original unit could), we need to make an extra subunitAtom for it and remove those bits from the next Atom.
          if (extraExtendedSubunitMatchCharacters > 0 && subunitMatches.length < extendedSubunitMatches.length) {
            // Add a SubAtom to the matrix for the extra bit of this Subunit which was in the next Atom.
            final SubAtom<U, X> extraSubunitAtom = Atom<Subunit<U>, X>(
              buildSubunit(nextUnitAtomContent.substring(0, extraExtendedSubunitMatchCharacters)),
              nextUnitAtom.context,
            );
            subunitUnitMatrix[subunitNumber][unitAtomNumber + 1] = extraSubunitAtom;
            // Remove those extracted characters from from the next UnitAtom's content.
            unitAtoms[unitAtomNumber + 1] = nextUnitAtom.withNewContent(StringUnit.build(
              U,
              nextUnitAtomContent.substring(extraExtendedSubunitMatchCharacters),
            ));
          }
        }
        // Create a subunit atom of the content for this subunit in this unitAtom
        final SubAtom<U, X> subunitAtom = Atom<Subunit<U>, X>(buildSubunit(subunitContent), unitAtomContext);
        subunitUnitMatrix[subunitNumber][unitAtomNumber] = subunitAtom;
        // Increment the subunitNumber if this subunitMatch was the last one in the unit atom (because we have logic above to "complete" partial subunits which span to the next unit atom, this effectively means that the subunitMatch will be the last in the subunit there are more matches in this atom, or if the extended unit has more matches than the unit does.
        if (subunitMatches.length < extendedSubunitMatches.length || subunitMatchIndex < subunitMatches.length - 1) {
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
      if (subunitAtoms.isNotEmpty && subunitAtoms.any((SubAtom<U, X>? subAtom) => subAtom != null)) {
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
