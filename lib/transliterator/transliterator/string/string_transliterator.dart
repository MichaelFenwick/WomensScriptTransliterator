part of womens_script_transliterator;

typedef AtomResult<U extends StringUnit, X> = Result<Atom<U, X>>;
typedef SubTrans<U extends StringUnit> = StringTransliterator<Subunit<U>>;
typedef SubResult<U extends StringUnit> = Result<Subunit<U>>;
typedef SubAtom<U extends StringUnit, X> = Atom<Subunit<U>, X>;
typedef SubAtomResult<U extends StringUnit, X> = Result<Atom<Subunit<U>, X>>;
typedef Matrix<E> = List<List<E>>;

abstract class StringTransliterator<U extends StringUnit> extends Transliterator<U> {
  StringTransliterator({
    required super.direction,
    Mode mode = const Mode(),
    Dictionary? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  U buildUnit(String string);

  U sourceReducer(U a, U b) => buildUnit('$a$b');

  U targetReducer(U a, U b) => buildUnit('$a$b');

  @override
  Result<U> transliterate(U input, {bool useOutputWriter = false});

  @override
  Iterable<Result<U>> transliterateAll(Iterable<U> inputs, {bool useOutputWriter = false}) =>
      inputs.map((U input) => transliterate(input, useOutputWriter: useOutputWriter));
}

mixin SuperUnitStringTransliterator<U extends StringUnit> on StringTransliterator<U> {
  SubTrans<U> getSubtransliterator();

  Subunit<U> buildSubunit(String string) => getSubtransliterator().buildUnit(string);

  @override
  Result<U> transliterate(U input, {bool useOutputWriter = false}) => splitMapJoin(input);

  ///Splits the contents of the [input] into [Subunit<Unit>]s, transliterates those [Subunit<Unit>]s, and then joins the results back into a [U].
  Result<U> splitMapJoin(
    U input, {
    SubResult<U> Function(String nonMatch)? onNonMatch,
    SubResult<U> Function(Match match)? onMatch,
  }) {
    final SubTrans<U> subtransliterator = getSubtransliterator();
    onMatch ??= (Match match) => subtransliterator.transliterate(buildSubunit(match[0]!));
    onNonMatch ??= (String nonMatch) => ResultPair<Subunit<U>>.fromValue(buildSubunit(nonMatch));

    final Iterable<Match> matches = input.splitIntoSubunits();
    int previousMatchEnd = 0;

    //if nothing matched, then treat the entire input as a nonMatch and return a corresponding Result.
    if (matches.isEmpty) {
      return onNonMatch(input.content).cast<U>((Subunit<U> subunit) => buildUnit(subunit.content));
    }

    Iterable<SubResult<U>> results() sync* {
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

    return Result.join<Subunit<U>>(
      results(),
      sourceReducer: subtransliterator.sourceReducer,
      targetReducer: subtransliterator.targetReducer,
    ).cast<U>((Subunit<U> subunit) => subunit.cast<U>());
  }

  // TODO: The type constraint on this is weaker than it should be. Ideally it'd accept Iterable<Atom<Unit, X>?>, but if it gets passed something of type Subunit<E> where E is the superunit of Unit, it won't accept those as being the same. The weaker type restriction is a work around until I figure out a better solution.
  /// Takes an [Iterable] of [Atom]s whose contents collectively represent one [StringUnit]'s content, and returns the [Result]s of transliteration on them.
  Iterable<AtomResult<U, X>?> transliterateAtoms<X>(Iterable<Atom<StringUnit, X>?> unitAtoms) {
    final SubTrans<U> subtransliterator = getSubtransliterator();

    // If the subtransliterator of this transliterator is a superunit, then we will recurse down into its transliterateAtoms method.
    if (subtransliterator is SuperUnitStringTransliterator<Subunit<U>>) {
      final Matrix<SubAtom<U, X>?> subunitUnitMatrix = _breakUnitAtomsIntoSubunitUnitMatrix<X>(unitAtoms);
      final Matrix<SubAtomResult<U, X>?> transliteratedUnitSubunitAtomMatrix = _transliterateSubunitUnitMatrix<X>(subunitUnitMatrix, subtransliterator);
      final Iterable<AtomResult<U, X>?> unitAtomResults =
          _joinTransliteratedSubunitResultAtomsIntoUnitResultAtoms<X>(transliteratedUnitSubunitAtomMatrix, subtransliterator);

      return unitAtomResults;
    }

    // But otherwise we're at the lowest level of unit, and if so, just call the basic transliterate() method.
    else {
      return unitAtoms.map<AtomResult<U, X>?>(
        (Atom<StringUnit, X>? unitAtom) =>
            unitAtom != null ? splitMapJoin(unitAtom.content as U).cast<Atom<U, X>>((StringUnit unit) => Atom<U, X>(unit as U, unitAtom.context)) : null,
      );
    }
  }

  /// Decomposes [unitAtomsList], which is a [List] of [Atom]s whose contents collectively represent one [StringUnit]'s content into a matrix of [Subunit<StringUnit>] Atoms. The element `matrix[i][j]` represents the part of the ith Subunit in the collective StringUnit whose contents are located in the jth Atom of the the collective StringUnit.
  Matrix<SubAtom<U, X>?> _breakUnitAtomsIntoSubunitUnitMatrix<X>(Iterable<Atom<StringUnit, X>?> unitAtoms) {
    //TODO: This would be better if I could rewrite this function to not require the casting to a list.
    final List<Atom<StringUnit, X>?> unitAtomsList = unitAtoms.toList();
    final Matrix<SubAtom<U, X>?> subunitUnitMatrix = <List<SubAtom<U, X>?>>[];
    int subunitNumber = 0;
    for (int unitAtomNumber = 0; unitAtomNumber < unitAtomsList.length; unitAtomNumber++) {
      if (unitAtomsList[unitAtomNumber] == null) {
        continue;
      }
      final bool isLastUnitAtom = unitAtomNumber == unitAtomsList.length - 1;
      final X unitAtomContext = unitAtomsList[unitAtomNumber]!.context; // This context will get passed to all subAtoms created from the contents of this Atom.
      final List<Match> subunitMatches = unitAtomsList[unitAtomNumber]!.content.splitIntoSubunits().toList();
      final Atom<StringUnit, X>? nextUnitAtom = isLastUnitAtom ? null : unitAtomsList[unitAtomNumber + 1];
      final String nextUnitAtomContent = nextUnitAtom?.content.content ?? '';
      // Create an "extended unit" which is this unit combined with the next one.
      final String extendedUnitContent = unitAtomsList[unitAtomNumber]!.content.content + nextUnitAtomContent;
      // And split that extended unit into subunits. These "extended subunits" can be used to see a subunit extends across the atom boundary, or the subunit ends at the same place as the unit does.
      final List<Match> extendedSubunitMatches = buildUnit(extendedUnitContent).splitIntoSubunits().toList();
      final int subunitCount = subunitNumber + subunitMatches.length;
      //On a new unitAtom, we need to add new subunit rows to the matrix of length equal to the total atom count.
      subunitUnitMatrix.addAll(
        Iterable<List<SubAtom<U, X>?>>.generate(
          subunitMatches.length,
          (int i) => List<SubAtom<U, X>?>.filled(unitAtomsList.length, null),
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
              nextUnitAtom.context, // Because this extra subAtom's content comes from the next Atom, we want to use that next Atom's context as well.
            );
            subunitUnitMatrix[subunitNumber][unitAtomNumber + 1] = extraSubunitAtom;
            // Remove those extracted characters from from the next UnitAtom's content.
            unitAtomsList[unitAtomNumber + 1] = nextUnitAtom.withNewContent(buildUnit(
              nextUnitAtomContent.substring(extraExtendedSubunitMatchCharacters),
            ));
          }
        }
        // Create a subunit atom of the content for this subunit in this unitAtom
        final SubAtom<U, X> subunitAtom = Atom<Subunit<U>, X>(buildSubunit(subunitContent), unitAtomContext);
        subunitUnitMatrix[subunitNumber][unitAtomNumber] = subunitAtom;
        // Increment the subunitNumber if one of the following is true:
        // * This subunitMatch was the last one in the unit atom (because we have logic above to "complete" partial subunits which span to the next unit atom, this effectively means that the subunitMatch will be the last in the subunit).
        // * There are more matches in this atom (meaning this atom contains at least one more subunit's start in it).
        // * The extended unit has more matches than the unit does (meaning that the next atom will contain the start of a new subunit).
        // * The next atom's content is now empty (meaning that this atom has reached the end of the subunit, and the atom after the next will start a new subunit).
        if (subunitMatches.length < extendedSubunitMatches.length || subunitMatchIndex < subunitMatches.length - 1 || nextUnitAtomContent.isEmpty) {
          subunitNumber++;
        }
      }
    }
    return subunitUnitMatrix;
  }

  /// Calls the appropriate [StringTransliterator] for to execute the transliteration of the [Subunit<StringUnit>] [Atom]s returned from [_breakUnitAtomsIntoSubunitUnitMatrix], once for each Subunit extracted from the original [StringUnit]'s Atoms. Returns a matrix of identical form to the [subunitUnitMatrix] passed in, except that the indices are transposed.
  Matrix<SubAtomResult<U, X>?> _transliterateSubunitUnitMatrix<X>(
    Matrix<SubAtom<U, X>?> subunitUnitMatrix,
    SuperUnitStringTransliterator<Subunit<U>> subtransliterator,
  ) {
    if (subunitUnitMatrix.isEmpty) {
      return <List<SubAtomResult<U, X>?>>[];
    }

    // Prebuild this matrix to be the transposed size of the sentenceParagraphAtomMatrix.
    final Matrix<SubAtomResult<U, X>?> transliteratedUnitSubunitAtomMatrix = List<List<SubAtomResult<U, X>?>>.of(
      Iterable<List<SubAtomResult<U, X>?>>.generate(
        subunitUnitMatrix.first.length,
        (int i) => List<SubAtomResult<U, X>?>.filled(subunitUnitMatrix.length, null),
      ),
    );

    //Send all the atoms for each subunit to the subunitTransliterator
    for (int subunitNumber = 0; subunitNumber < subunitUnitMatrix.length; subunitNumber++) {
      // A list of the subunit atoms which comprise the entire subunit, indexed by which unitAtom it came from.
      final List<SubAtom<U, X>?> subunitAtoms = subunitUnitMatrix[subunitNumber];
      if (subunitAtoms.isNotEmpty && subunitAtoms.any((SubAtom<U, X>? subAtom) => subAtom != null)) {
        //A list of transliterated subunit atoms results which comprise the entire subunit, indexed by which unitAtom it came from.
        final List<SubAtomResult<U, X>?> transliteratedSubunitAtoms = subtransliterator.transliterateAtoms<X>(subunitAtoms).toList();
        for (int unitNumber = 0; unitNumber < transliteratedSubunitAtoms.length; unitNumber++) {
          transliteratedUnitSubunitAtomMatrix[unitNumber][subunitNumber] = transliteratedSubunitAtoms[unitNumber];
        }
      }
    }
    return transliteratedUnitSubunitAtomMatrix;
  }

  /// Recomposes the [transliteratedUnitSubunitAtomMatrix] into a [List] of [Result]s, with each Result containing the transliteration of an [Atom] of the original [StringUnit].
  List<AtomResult<U, X>?> _joinTransliteratedSubunitResultAtomsIntoUnitResultAtoms<X>(
    Matrix<SubAtomResult<U, X>?> transliteratedUnitSubunitAtomMatrix,
    SuperUnitStringTransliterator<Subunit<U>> subtransliterator,
  ) {
    SubAtom<U, X> atomSourceReducer(SubAtom<U, X> a, SubAtom<U, X> b) => a.withNewContent(subtransliterator.sourceReducer(a.content, b.content));
    SubAtom<U, X> atomTargetReducer(SubAtom<U, X> a, SubAtom<U, X> b) => a.withNewContent(subtransliterator.targetReducer(a.content, b.content));

    final List<AtomResult<U, X>?> unitAtomResults = <AtomResult<U, X>?>[];
    for (final List<SubAtomResult<U, X>?> unitSubunitAtomResults in transliteratedUnitSubunitAtomMatrix) {
      final Iterable<SubAtomResult<U, X>> nonNullUnitSubunitAtomResults = unitSubunitAtomResults.whereType<SubAtomResult<U, X>>();
      if (nonNullUnitSubunitAtomResults.isNotEmpty) {
        unitAtomResults.add(Result.join<SubAtom<U, X>>(
          nonNullUnitSubunitAtomResults,
          sourceReducer: atomSourceReducer,
          targetReducer: atomTargetReducer,
        ).cast<Atom<U, X>>((SubAtom<U, X> subunitAtom) => Atom<U, X>(subunitAtom.content.cast<U>(), subunitAtom.context)));
      }
    }

    return unitAtomResults;
  }
}
