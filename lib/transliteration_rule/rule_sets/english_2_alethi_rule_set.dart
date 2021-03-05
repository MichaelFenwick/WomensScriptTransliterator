part of transliteration_rule;

RuleSet<English, Alethi> english2AlethiRuleSet = RuleSet<English, Alethi>(<Rule<English, Alethi>>[
  // Letters not at the start of another rule (having these first allow for early bailing if we know that another rule can't possibly be matched).
  ...'abdefghijklnopqruvyz'.split('').map((String letter) => Rule<English, Alethi>(
        <String>[letter],
        anywhere,
        ResultSet<String, English, Alethi>.fromIterable(letter, <String>[letter]),
        '',
      )),

  // The easy digraphs
  Rule<English, Alethi>(
    <String>['th'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('th', <String>['<', 'th']),
    'Replace any instances of `th` with the Women\'s Script `<` character.',
  ),
  Rule<English, Alethi>(
    <String>['sh'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('sh', <String>['>', 'sh']),
    'Replace any instances of `sh` with the Women\'s Script `>` character.',
  ),
  Rule<English, Alethi>(
    <String>['ck'],
    anywhereButStart,
    ResultSet<String, English, Alethi>.fromIterable('ck', <String>['k', 'kk', 'sk']),
    'Replace any instances of `ck` with just a `k`.',
  ),
  Rule<English, Alethi>(
    <String>['wr'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('wr', <String>['r', 'wr']),
    'Replace any instances of `wr` with just an `r`.',
  ),

  // Handle the letter X
  Rule<English, Alethi>(
    <String>['x'],
    startOnly,
    ResultSet<String, English, Alethi>.fromIterable('x', <String>['z', 'x']),
    'Replace an `x` at the start of a word with a `z`',
  ),
  Rule<English, Alethi>(
    <String>['x'],
    anywhereButStart,
    ResultSet<String, English, Alethi>.fromIterable('x', <String>['x', 'z']),
    'Replace an `x` anywhere except the start of a word with an `x` (the font itself will turn this into a `ks`).',
  ),

  // SC polyglyphs
  Rule<English, Alethi>(
    <String>['sch'],
    startOnly,
    ResultSet<String, English, Alethi>.fromIterable('sch', <String>['sk', 'skh', 'ssh', 'sC']),
    'Replace `sch` at the start of words with `sk`.',
  ),
  Rule<English, Alethi>(
    //TODO: This is a pretty weak rule. I should look to see if I can't come up with a better way to guess at what the `sch` should be, or maybe if it'd be better to just transliterate the `s` and leave the following `ch` to be handled by other rules. This rule is just assuming that any instances of sch in the middle of a word is part of a compound word for the most part.
    <String>['sch'],
    anywhereButStart,
    ResultSet<String, English, Alethi>.fromIterable('sch', <String>['sC', 'sk', 'skh', 'ssh']),
    'Replace `sch` anywhere except the start of words with `sC` as a best guess of what it might be.',
  ),
  Rule<English, Alethi>(
    <String>['sci'],
    startOnly,
    ResultSet<String, English, Alethi>.fromIterable('sci', <String>['si', 'ski', 'ssi', 's>']),
    'Replace `sci` at the start of a word with `si`.',
  ),
  Rule<English, Alethi>(
    <String>['scious'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('scious', <String>['>ous', 'skious', 'ssious', 's>ous']),
    'Replace `scious` with `>ous`.',
  ),

  // The SC diglyph
  Rule<English, Alethi>(
    <String>['sc'],
    startOnly,
    ResultSet<String, English, Alethi>.fromIterable('sc', <String>['s', 'sk', 'ss']),
    'Replace `sc` at the start of words with just an `s`.',
  ),
  Rule<English, Alethi>(
    <String>['sc'],
    anywhereButStart,
    ResultSet<String, English, Alethi>.fromIterable('s', <String>['s', 'k']),
    'If `sc` is found in the middle/end of words, just transliterate the `s` alone, and leave the `c` for the next loop.',
  ),

  // MC and MAC
  Rule<English, Alethi>(
    <String>['mc'],
    startOnly,
    ResultSet<String, English, Alethi>.fromIterable('mc', <String>['mk', 'ms']),
    'Replace `mc` at the start of words with `mk`, assuming it\'s a Scottish name.',
  ),
  Rule<English, Alethi>(
    <String>['mac'],
    startOnly,
    ResultSet<String, English, Alethi>.fromIterable('mac', <String>['mak', 'mas']),
    'Replace `mac` at the start of words with `mak`, assuming it\'s a Scottish name, so long as it isn\'t followed by a letter which commonly follows `c`.',
    denyPatterns: <String>['maca', 'mace', 'mach', 'maci', 'maco', 'macu', 'macy'],
  ),

  // CH and CH polyglyphs
  Rule<English, Alethi>(
    <String>['chr'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('chr', <String>['kr', 'Cr', 'khr', 'shr']),
    'Replace `chr` in words with a `kr`.',
  ),
  Rule<English, Alethi>(
    <String>['ch'],
    endOnly,
    ResultSet<String, English, Alethi>.fromIterable('ch', <String>['C', 'kh', 'sh']),
    'Replace a `ch` at the end of a word with a Women\'s Script `C` character.',
  ),
  //TODO: This rule shouldn't be applied if the match is `cha` and is preceeded by a `c`. Hopefully the rule for `cc` would process this away so the `cha` is never seen, but I need to make sure that that actually is the case.
  Rule<English, Alethi>(
    <String>['cha', 'che', 'chi', 'cho', 'chu', 'chy'],
    startOnly,
    ResultSet<String, English, Alethi>.fromIterable('ch', <String>['C', 'kh', 'sh']),
    'Replace a `ch` followed by a vowel at the start of a word with a Women\'s Script `C` character.',
  ),
  Rule<English, Alethi>(
    <String>['ch'],
    startOnly,
    ResultSet<String, English, Alethi>.fromIterable('ch', <String>['k', 'C', 'kh', 'sh']),
    'Replace `ch` at the start of a work followed by a non-vowel with `k`.',
    denyPatterns: <String>['cha', 'che', 'chi', 'cho', 'chu', 'chy'],
  ),
  Rule<English, Alethi>(
    <String>['ch'],
    middleOnly,
    ResultSet<String, English, Alethi>.fromIterable('ch', <String>['k', 'C', 'kh', 'sh']),
    'Replace `ch` in the middle of words with a Women\'s Script `C` character as a best guess.',
  ),

  // Polyglyphs starting with C
  Rule<English, Alethi>(
    <String>['ca', 'cl', 'co', 'cr', 'ct', 'cu'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('c', <String>['k', 's']),
    'Replace `c` with a `k` when it\'s followed by on of [alortu]',
  ),
  Rule<English, Alethi>(
    <String>['c'],
    endOnly,
    ResultSet<String, English, Alethi>.fromIterable('c', <String>['k', 's']),
    'Replace `c` at the end of words with `k`.',
  ),
  Rule<English, Alethi>(
    <String>['cs'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('cs', <String>['ks', 'ss']),
    'Replace `cs` with a `ks` (This is a separate rule because it needs to consume the `s` as well as the `c`)',
  ),
  Rule<English, Alethi>(
    <String>['cean'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('cean', <String>['>an', 'kean', 'sean']),
    'Replace `cean` with `>an`',
  ),
  Rule<English, Alethi>(
    <String>['ceous'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('ceous', <String>['>ous', 'keous', 'seous']),
    'Replace `ceous` with `>ous`',
  ),
  Rule<English, Alethi>(
    <String>['ce'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('c', <String>['s', 'k']),
    'Replace the `c` in `ce` with an `s`.',
  ),
  Rule<English, Alethi>(
    <String>['ciab', 'cial', 'cian', 'ciat', 'cien', 'cious'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('ci', <String>['>', 'ki', 'si']),
    'Replace the `ci` at the start of certain letter sequences with the Women\'s Script `>` character.',
  ),
  Rule<English, Alethi>(
    <String>['cing'],
    //TODO: Figure out whether `sing` or `king` is more likely to be correct, or maybe if one is more likely to be correct if we're at the start/end/middle of a word
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('cing', <String>['', '']),
    '',
  ),
  Rule<English, Alethi>(
    <String>['ci'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('ci', <String>['si', 'ki', '>']),
    'Replace `ci` without any special endings with `si`.',
  ),
  // The letter C in other contexts C[^AEHIKLORSTUY\n]
  //TODO: Do some legwork to make sure this is as good as rule as I think
  Rule<English, Alethi>(
    <String>['cc'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('c', <String>['k', 's']),
    'Replace the first `c` in `cc` as a `k`, leaving the second one to be processed in the next loop.',
  ),
  Rule<English, Alethi>(
    <String>['cqu'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('cqu', <String>['k', 'kqu', 'squ']),
    'Replace `cqu` with just a `k` to handle words like "lacquer."',
  ),
  Rule<English, Alethi>(
    <String>['cw'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('c', <String>['k', 's']),
    'Replace the `c` of `cw` with `k`, assuming that the `c` is at the end of syllable.',
  ),
  Rule<English, Alethi>(
    <String>['cz'],
    anywhereButMiddle,
    ResultSet<String, English, Alethi>.fromIterable('cz', <String>['C', 'kz', 'sz']),
    'Replace `cz` at the start or end of words with the Women\'s Script C letter.',
  ),
  Rule<English, Alethi>(
    <String>['cz'],
    middleOnly,
    ResultSet<String, English, Alethi>.fromIterable('c', <String>['k', 's']),
    'Replace `cz` in the middle of a word with `k`, assuming that the `c` is at the end of a syllable.',
  ),
  Rule<English, Alethi>(
    <String>['c'],
    anywhere,
    ResultSet<String, English, Alethi>.fromIterable('c', <String>['k', 's']),
    'Replace any `c` which hasn\'t been matched by a previous rule with a `k`, assuming that the `c` is at the end of a syllable.',
  ),
]);
