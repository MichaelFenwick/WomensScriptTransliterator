part of womens_script_transliterator;

//Note that order matters for the purposes of producing a best-guess transliteration, as the first matching [Rule] will be used for that.
RuleSet<English, Alethi> english2AlethiRuleSet = RuleSet<English, Alethi>(<Rule<English, Alethi>>[
  // Letters which aren't found at the start of another rule. By having these first, we can avoid checking the other rules in most cases in cases where only the first option is desired. Further, these are in order of letter frequency, which minimizes the number of letters that need to be tested in this way.
  ...'eaoinhrdlufgypbvkjqz'.split('').map((String letter) => Rule<English, Alethi>(
        <Pattern>[letter],
        anywhere,
        <OptionSet<English, Alethi>>[
          OptionSet<English, Alethi>(letter, <String>[letter]),
        ],
        '',
      )),

  // Highly specific rules that won't match most words, but prevent the more common rules from ruining a specific small class of words. Note, these rules have only been added after ensuring that they don't cause the mistransliteration of other words.
  Rule<English, Alethi>(
    <Pattern>['csh'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('csh', <String>['k>', 's>', 'ksh', 'ssh'])
    ],
    'Replace `csh` with `k>` since that polyglyph is only found in compound words.',
  ),
  Rule<English, Alethi>(
    <Pattern>['cknowl'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('cknowl', <String>['kknowl', 'knowl', 'sknowl'])
    ],
    'Replace `cknowl` with `kknowl` to handle `acknowledge` and all its derivative words.',
  ),
  Rule<English, Alethi>(
    <Pattern>['sych'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('sych', <String>['syk', 'syc', 'sysh', 'sykh'])
    ],
    'Replace `sych` with `syk` to handle `psych` and its derivative words.',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('(?<=[mt]e)ch')],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ch', <String>['k', 'c', 'sh', 'kh'])
    ],
    'Replace `ch` in `tech` and `mech` with `k` to handle `technical` and `mechanical` and their derivative words.',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp(r'(?<=(?<!m|se|p|l|st)ar)ch([^e]|$)'), RegExp('(?<=ar)che[^rds]')],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ch', <String>['k', 'c', 'sh', 'kh'])
    ],
    'Most instances of `arch` should be replaced with `ark`. Words like `march`, `search`, `archer`, and `parchment` are exceptions to this however.',
  ),
  Rule<English, Alethi>(
    <Pattern>['chasm', 'chiti', 'chao'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ch', <String>['k', 'c', 'kh', 'sh'])
    ],
    'Replace `ch` with `k` for words like `chasm`, `chitin`, and `chaos`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['charact'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('charact', <String>['karakt', 'carakt', 'karast', 'carast'])
    ],
    'Replace `charact` with `karact` for words like `character`.',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('(?<!s)chem(?!ent)')],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('chem', <String>['kem', 'cem', 'khem', 'shem'])
    ],
    'Replace the `chem` with `kem` for words like `chemistry`. Because `ment` is a common suffix though, don\'t apply this to instances of `chement`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['chor'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('chor', <String>['kor', 'cor', 'khor', 'shor'])
    ],
    'Replace `chor` with `kor` for words like `chorus` or `chord`. There are some exceptions to this rule, but they are less common than the words this rule correctly applies to.',
  ),

  // The easy digraphs
  Rule<English, Alethi>(
    <Pattern>['th'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('th', <String>['<', 'th'])
    ],
    'Replace any instances of `th` with the Women\'s Script `<` character.',
  ),
  Rule<English, Alethi>(
    <Pattern>['sh'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('sh', <String>['>', 'sh'])
    ],
    'Replace any instances of `sh` with the Women\'s Script `>` character.',
  ),
  Rule<English, Alethi>(
    <Pattern>['ck'],
    anywhereButStart,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ck', <String>['k', 'kk', 'sk'])
    ],
    'Replace any instances of `ck` with just a `k`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['wr'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('wr', <String>['r', 'wr'])
    ],
    'Replace any instances of `wr` with just an `r`.',
  ),

  // Handle the letter X
  Rule<English, Alethi>(
    <Pattern>[RegExp('(?<=[aeiou][eiou])x')],
    endOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('x', <String>['', 'x'])
    ],
    'Replace an `x` at the end of word with nothing if it is preceded by two vowels, to handle words which come from French. Words ending with `ax` are an exception to this however.',
  ),
  Rule<English, Alethi>(
    <Pattern>['x'],
    startOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('x', <String>['z', 'x'])
    ],
    'Replace an `x` at the start of a word with a `z`',
  ),
  Rule<English, Alethi>(
    <Pattern>['x'],
    anywhereButStart,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('x', <String>['x', 'z'])
    ],
    'Replace an `x` anywhere except the start of a word with an `x` (the font itself will turn this into a `ks`).',
  ),

  // SC polyglyphs
  Rule<English, Alethi>(
    <Pattern>[RegExp('sch[nmlr]')],
    startOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('sch', <String>['>', 'sk', 'sc', 'skh', 'ssh'])
    ],
    'Replace `sch` at the start of words with `>` if it\'s followed by a letter that indicates that is probably of German/Yiddish origin.',
  ),
  Rule<English, Alethi>(
    <Pattern>['sch'],
    startOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('sch', <String>['sk', 'skh', 'ssh', 'sc', '>'])
    ],
    'Replace `sch` at the start of words with `sk`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['sch'],
    anywhereButStart,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('sch', <String>['sc', 'sk', '>', 'skh', 'ssh'])
    ],
    'Replace `sch` anywhere except the start of words with `sc` as a best guess of what it might be.',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('(?<=con|omni)sci')],
    anywhereButStart,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('sci', <String>['>', 'ski', 'ssi', 's>'])
    ],
    'Replace `sci` with `>` when preceded by `con` or `omni`. This rule exists almost exclusively for the word `conscious` and its numerous derivative words.',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('scious')],
    anywhereButStart,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('scious', <String>['>ous'])
    ],
    'Replace `scious` with `>ous`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['sci'],
    startOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('sci', <String>['si', 'ski', 'ssi', 's>'])
    ],
    'Replace `sci` at the start of a word with `si`.',
  ),

  // The SC diglyph
  Rule<English, Alethi>(
    <Pattern>[RegExp('sc[eiy]')],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('sc', <String>['s', 'sk', 'ss'])
    ],
    'Replace `sc` at the start of words with just an `s` if followed by [eiy] (the letters that generally cause `c` to sound like an `s`).',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('sc[^eiy]')],
    startOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('sc', <String>['sk', 's', 'ss'])
    ],
    'Replace `sc` at the start of words with just an `sk` if not followed by [eiy].',
  ),
  Rule<English, Alethi>(
    <Pattern>['sc'],
    anywhereButStart,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('s', <String>['s']),
      OptionSet<English, Alethi>('sc', <String>['s', '>']),
    ],
    'If `sc` is found in the middle/end of words, just transliterate the `s` alone, and leave the `c` for the next loop.',
  ),

  // MC and MAC
  Rule<English, Alethi>(
    <Pattern>['mc'],
    startOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('mc', <String>['mk', 'ms'])
    ],
    'Replace `mc` at the start of words with `mk`, assuming it\'s a Scottish name.',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('mac[^aehiouy]')],
    startOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('mac', <String>['mak', 'mas'])
    ],
    'Replace `mac` at the start of words with `mak`, assuming it\'s a Scottish name, so long as it isn\'t followed by a letter which commonly follows `c`.',
  ),

  // CH and CH polyglyphs
  Rule<English, Alethi>(
    <Pattern>['chr'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('chr', <String>['kr', 'cr', 'khr', 'shr'])
    ],
    'Replace `chr` in words with a `kr`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['ch'],
    endOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ch', <String>['c', 'k', 'kh', 'sh', '>'])
    ],
    'Replace a `ch` at the end of a word with a Women\'s Script `c` character.',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('(?<!c)cha'), RegExp(r'ch([eiouy]|$)')],
    startOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ch', <String>['c', 'k', 'kh', 'sh', '>'])
    ],
    'Replace a `ch` followed by a vowel at the start of a word with a Women\'s Script `c` character (expect for the case of `ccha`)',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('ch[^aeiouy]')],
    startOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ch', <String>['k', 'c', 'kh', 'sh', '>'])
    ],
    'Replace `ch` at the start of a word followed by a non-vowel with `k`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['ch'],
    middleOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ch', <String>['c', 'k', 'kh', 'sh', '>'])
    ],
    'Replace `ch` in the middle of words with a Women\'s Script `c` character as a best guess.',
  ),

  // Polyglyphs starting with C
  Rule<English, Alethi>(
    <Pattern>[RegExp('c[alortu]')],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('c', <String>['k', 's'])
    ],
    'Replace `c` with a `k` when it\'s followed by one of [alortu].',
  ),
  Rule<English, Alethi>(
    <Pattern>['c'],
    endOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('c', <String>['k', 's'])
    ],
    'Replace `c` at the end of words with `k`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['cs'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('cs', <String>['ks', 'ss'])
    ],
    'Replace `cs` with a `ks` (This is a separate rule because it needs to consume the `s` as well as the `c`).',
  ),
  Rule<English, Alethi>(
    <Pattern>['cean'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('cean', <String>['>an', 'kean', 'sean'])
    ],
    'Replace `cean` with `>an`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['ceous'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ceous', <String>['>ous', 'keous', 'seous'])
    ],
    'Replace `ceous` with `>ous`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['ce'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('c', <String>['s', 'k'])
    ],
    'Replace the `c` in `ce` with an `s`.',
  ),
  Rule<English, Alethi>(
    <Pattern>['ciab', 'cial', 'cian', 'cien', 'cion', 'cious'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ci', <String>['>', 'ki', 'si'])
    ],
    'Replace the `ci` at the start of certain letter sequences with the Women\'s Script `>` character.',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('(?<=[eiu])ciat')],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ci', <String>['>i', '>', 'ki', 'si'])
    ],
    'Replace the `ci` in `ciat` with the Women\'s Script `>` character when it is preceded by one of [eiu].',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('(?<![eiu])ciat')],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ci', <String>['si', '>i', '>', 'ki'])
    ],
    'Replace the `ci` in `ciat` with `si` when it is not preceded by one of [eiu].',
  ),
  Rule<English, Alethi>(
    <Pattern>['cing'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('cing', <String>['sing', 'king'])
    ],
    '',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('ci')],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('ci', <String>['si', 'ki', '>'])
    ],
    'Replace `ci` without any special endings with `si`.',
  ),
  Rule<English, Alethi>(
    <Pattern>[RegExp('cy')],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('cy', <String>['sy', 'ky'])
    ],
    'Replace `cy` with `sy`.',
  ),

  // The letter C in other contexts C[^AEHIKLORSTUY\n]
  Rule<English, Alethi>(
    <Pattern>['cc'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('c', <String>['k', 's'])
    ],
    'Replace the first `c` in `cc` as a `k`, leaving the second one to be processed in the next loop.',
  ),
  Rule<English, Alethi>(
    <Pattern>['cqu'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('cqu', <String>['kqu', 'k', 'squ'])
    ],
    'Replace `cqu` with `cqu` in most cases, but also give the potential option of just a `k` to handle words like "lacquer."',
  ),
  Rule<English, Alethi>(
    <Pattern>['cw'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('c', <String>['k', 's'])
    ],
    'Replace the `c` of `cw` with `k`, assuming that the `c` is at the end of syllable.',
  ),
  Rule<English, Alethi>(
    <Pattern>['cz'],
    anywhereButMiddle,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('cz', <String>['c', 'kz', 'sz', 'tz'])
    ],
    'Replace `cz` at the start or end of words with the Women\'s Script c letter.',
  ),
  Rule<English, Alethi>(
    <Pattern>['cz'],
    middleOnly,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('c', <String>['k', 's', 't'])
    ],
    'Replace `cz` in the middle of a word with `k`, assuming that the `c` is at the end of a syllable.',
  ),
  Rule<English, Alethi>(
    <Pattern>['c'],
    anywhere,
    <OptionSet<English, Alethi>>[
      OptionSet<English, Alethi>('c', <String>['k', 's'])
    ],
    'Replace any `c` which hasn\'t been matched by a previous rule with a `k`, assuming that the `c` is at the end of a syllable.',
  ),
]);
