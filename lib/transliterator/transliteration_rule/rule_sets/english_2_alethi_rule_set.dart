part of womens_script_transliterator;

//Note that order matters for the purposes of producing a best-guess transliteration, as the first matching [Rule] will be used for that.
RuleSet english2AlethiRuleSet = RuleSet(<Rule>[
  // Letters which aren't found at the start of another rule. By having these first, we can avoid checking the other rules in most cases in cases where only the first option is desired. Further, these are in order of letter frequency, which minimizes the number of letters that need to be tested in this way.
  ...'eaoinhrdlufgypbvkjqz'.split('').map((String letter) => Rule(
        <Pattern>[letter],
        anywhere,
        <OptionSet>[
          OptionSet(letter, <String>[letter]),
        ],
        '',
      )),

  // Highly specific rules that won't match most words, but prevent the more common rules from ruining a specific small class of words. Note, these rules have only been added after ensuring that they don't cause the mistransliteration of other words.
  Rule(
    <Pattern>['csh'],
    anywhere,
    <OptionSet>[
      OptionSet('csh', <String>['k>', 's>', 'ksh', 'ssh'])
    ],
    'Replace `csh` with `k>` since that polyglyph is only found in compound words.',
  ),
  Rule(
    <Pattern>['cknowl'],
    anywhere,
    <OptionSet>[
      OptionSet('cknowl', <String>['kknowl', 'knowl', 'sknowl'])
    ],
    'Replace `cknowl` with `kknowl` to handle `acknowledge` and all its derivative words.',
  ),
  Rule(
    <Pattern>['sych'],
    anywhere,
    <OptionSet>[
      OptionSet('sych', <String>['syk', 'syc', 'sysh', 'sykh'])
    ],
    'Replace `sych` with `syk` to handle `psych` and its derivative words.',
  ),
  Rule(
    <Pattern>[RegExp('(?<=[mt]e)ch')],
    anywhere,
    <OptionSet>[
      OptionSet('ch', <String>['k', 'c', 'sh', 'kh'])
    ],
    'Replace `ch` in `tech` and `mech` with `k` to handle `technical` and `mechanical` and their derivative words.',
  ),
  Rule(
    <Pattern>[RegExp(r'(?<=(?<!m|se|p|l|st)ar)ch([^e]|$)'), RegExp('(?<=ar)che[^rds]')],
    anywhere,
    <OptionSet>[
      OptionSet('ch', <String>['k', 'c', 'sh', 'kh'])
    ],
    'Most instances of `arch` should be replaced with `ark`. Words like `march`, `search`, `archer`, and `parchment` are exceptions to this however.',
  ),
  Rule(
    <Pattern>['chasm', 'chiti', 'chao'],
    anywhere,
    <OptionSet>[
      OptionSet('ch', <String>['k', 'c', 'kh', 'sh'])
    ],
    'Replace `ch` with `k` for words like `chasm`, `chitin`, and `chaos`.',
  ),
  Rule(
    <Pattern>['charact'],
    anywhere,
    <OptionSet>[
      OptionSet('charact', <String>['karakt', 'carakt', 'karast', 'carast'])
    ],
    'Replace `charact` with `karact` for words like `character`.',
  ),
  Rule(
    <Pattern>[RegExp('(?<!s)chem(?!ent)')],
    anywhere,
    <OptionSet>[
      OptionSet('chem', <String>['kem', 'cem', 'khem', 'shem'])
    ],
    'Replace the `chem` with `kem` for words like `chemistry`. Because `ment` is a common suffix though, don\'t apply this to instances of `chement`.',
  ),
  Rule(
    <Pattern>['chor'],
    anywhere,
    <OptionSet>[
      OptionSet('chor', <String>['kor', 'cor', 'khor', 'shor'])
    ],
    'Replace `chor` with `kor` for words like `chorus` or `chord`. There are some exceptions to this rule, but they are less common than the words this rule correctly applies to.',
  ),

  // The easy digraphs
  Rule(
    <Pattern>['th'],
    anywhere,
    <OptionSet>[
      OptionSet('th', <String>['<', 'th'])
    ],
    'Replace any instances of `th` with the Women\'s Script `<` character.',
  ),
  Rule(
    <Pattern>['sh'],
    anywhere,
    <OptionSet>[
      OptionSet('sh', <String>['>', 'sh'])
    ],
    'Replace any instances of `sh` with the Women\'s Script `>` character.',
  ),
  Rule(
    <Pattern>['ck'],
    anywhereButStart,
    <OptionSet>[
      OptionSet('ck', <String>['k', 'kk', 'sk'])
    ],
    'Replace any instances of `ck` with just a `k`.',
  ),
  Rule(
    <Pattern>['wr'],
    anywhere,
    <OptionSet>[
      OptionSet('wr', <String>['r', 'wr'])
    ],
    'Replace any instances of `wr` with just an `r`.',
  ),

  // Handle the letter X
  Rule(
    <Pattern>[RegExp('(?<=[aeiou][eiou])x')],
    endOnly,
    <OptionSet>[
      OptionSet('x', <String>['', 'x'])
    ],
    'Replace an `x` at the end of word with nothing if it is preceded by two vowels, to handle words which come from French. Words ending with `ax` are an exception to this however.',
  ),
  Rule(
    <Pattern>['x'],
    startOnly,
    <OptionSet>[
      OptionSet('x', <String>['z', 'x'])
    ],
    'Replace an `x` at the start of a word with a `z`',
  ),
  Rule(
    <Pattern>['x'],
    anywhereButStart,
    <OptionSet>[
      OptionSet('x', <String>['x', 'z'])
    ],
    'Replace an `x` anywhere except the start of a word with an `x` (the font itself will turn this into a `ks`).',
  ),

  // SC polyglyphs
  Rule(
    <Pattern>[RegExp('sch[nmlr]')],
    startOnly,
    <OptionSet>[
      OptionSet('sch', <String>['>', 'sk', 'sc', 'skh', 'ssh'])
    ],
    'Replace `sch` at the start of words with `>` if it\'s followed by a letter that indicates that is probably of German/Yiddish origin.',
  ),
  Rule(
    <Pattern>['sch'],
    startOnly,
    <OptionSet>[
      OptionSet('sch', <String>['sk', 'skh', 'ssh', 'sc', '>'])
    ],
    'Replace `sch` at the start of words with `sk`.',
  ),
  Rule(
    <Pattern>['sch'],
    anywhereButStart,
    <OptionSet>[
      OptionSet('sch', <String>['sc', 'sk', '>', 'skh', 'ssh'])
    ],
    'Replace `sch` anywhere except the start of words with `sc` as a best guess of what it might be.',
  ),
  Rule(
    <Pattern>[RegExp('(?<=con|omni)sci')],
    anywhereButStart,
    <OptionSet>[
      OptionSet('sci', <String>['>', 'ski', 'ssi', 's>'])
    ],
    'Replace `sci` with `>` when preceded by `con` or `omni`. This rule exists almost exclusively for the word `conscious` and its numerous derivative words.',
  ),
  Rule(
    <Pattern>[RegExp('scious')],
    anywhereButStart,
    <OptionSet>[
      OptionSet('scious', <String>['>ous'])
    ],
    'Replace `scious` with `>ous`.',
  ),
  Rule(
    <Pattern>['sci'],
    startOnly,
    <OptionSet>[
      OptionSet('sci', <String>['si', 'ski', 'ssi', 's>'])
    ],
    'Replace `sci` at the start of a word with `si`.',
  ),

  // The SC diglyph
  Rule(
    <Pattern>[RegExp('sc[eiy]')],
    anywhere,
    <OptionSet>[
      OptionSet('sc', <String>['s', 'sk', 'ss'])
    ],
    'Replace `sc` at the start of words with just an `s` if followed by [eiy] (the letters that generally cause `c` to sound like an `s`).',
  ),
  Rule(
    <Pattern>[RegExp('sc[^eiy]')],
    startOnly,
    <OptionSet>[
      OptionSet('sc', <String>['sk', 's', 'ss'])
    ],
    'Replace `sc` at the start of words with just an `sk` if not followed by [eiy].',
  ),
  Rule(
    <Pattern>['sc'],
    anywhereButStart,
    <OptionSet>[
      OptionSet('s', <String>['s']),
      OptionSet('sc', <String>['s', '>']),
    ],
    'If `sc` is found in the middle/end of words, just transliterate the `s` alone, and leave the `c` for the next loop.',
  ),

  // MC and MAC
  Rule(
    <Pattern>['mc'],
    startOnly,
    <OptionSet>[
      OptionSet('mc', <String>['mk', 'ms'])
    ],
    'Replace `mc` at the start of words with `mk`, assuming it\'s a Scottish name.',
  ),
  Rule(
    <Pattern>[RegExp('mac[^aehiouy]')],
    startOnly,
    <OptionSet>[
      OptionSet('mac', <String>['mak', 'mas'])
    ],
    'Replace `mac` at the start of words with `mak`, assuming it\'s a Scottish name, so long as it isn\'t followed by a letter which commonly follows `c`.',
  ),

  // CH and CH polyglyphs
  Rule(
    <Pattern>['chr'],
    anywhere,
    <OptionSet>[
      OptionSet('chr', <String>['kr', 'cr', 'khr', 'shr'])
    ],
    'Replace `chr` in words with a `kr`.',
  ),
  Rule(
    <Pattern>['ch'],
    endOnly,
    <OptionSet>[
      OptionSet('ch', <String>['c', 'k', 'kh', 'sh', '>'])
    ],
    'Replace a `ch` at the end of a word with a Women\'s Script `c` character.',
  ),
  Rule(
    <Pattern>[RegExp('(?<!c)cha'), RegExp(r'ch([eiouy]|$)')],
    startOnly,
    <OptionSet>[
      OptionSet('ch', <String>['c', 'k', 'kh', 'sh', '>'])
    ],
    'Replace a `ch` followed by a vowel at the start of a word with a Women\'s Script `c` character (except for the case of `ccha`)',
  ),
  Rule(
    <Pattern>[RegExp('ch[^aeiouy]')],
    startOnly,
    <OptionSet>[
      OptionSet('ch', <String>['k', 'c', 'kh', 'sh', '>'])
    ],
    'Replace `ch` at the start of a word followed by a non-vowel with `k`.',
  ),
  Rule(
    <Pattern>['ch'],
    middleOnly,
    <OptionSet>[
      OptionSet('ch', <String>['c', 'k', 'kh', 'sh', '>'])
    ],
    'Replace `ch` in the middle of words with a Women\'s Script `c` character as a best guess.',
  ),

  // Polyglyphs starting with C
  Rule(
    <Pattern>[RegExp('c[alortu]')],
    anywhere,
    <OptionSet>[
      OptionSet('c', <String>['k', 's'])
    ],
    'Replace `c` with a `k` when it\'s followed by one of [alortu].',
  ),
  Rule(
    <Pattern>['c'],
    endOnly,
    <OptionSet>[
      OptionSet('c', <String>['k', 's'])
    ],
    'Replace `c` at the end of words with `k`.',
  ),
  Rule(
    <Pattern>['cs'],
    anywhere,
    <OptionSet>[
      OptionSet('cs', <String>['ks', 'ss'])
    ],
    'Replace `cs` with a `ks` (This is a separate rule because it needs to consume the `s` as well as the `c`).',
  ),
  Rule(
    <Pattern>['cean'],
    anywhere,
    <OptionSet>[
      OptionSet('cean', <String>['>an', 'kean', 'sean'])
    ],
    'Replace `cean` with `>an`.',
  ),
  Rule(
    <Pattern>['ceous'],
    anywhere,
    <OptionSet>[
      OptionSet('ceous', <String>['>ous', 'keous', 'seous'])
    ],
    'Replace `ceous` with `>ous`.',
  ),
  Rule(
    <Pattern>['ce'],
    anywhere,
    <OptionSet>[
      OptionSet('c', <String>['s', 'k'])
    ],
    'Replace the `c` in `ce` with an `s`.',
  ),
  Rule(
    <Pattern>['ciab', 'cial', 'cian', 'cien', 'cion', 'cious'],
    anywhere,
    <OptionSet>[
      OptionSet('ci', <String>['>', 'ki', 'si'])
    ],
    'Replace the `ci` at the start of certain letter sequences with the Women\'s Script `>` character.',
  ),
  Rule(
    <Pattern>[RegExp('(?<=[eiu])ciat')],
    anywhere,
    <OptionSet>[
      OptionSet('ci', <String>['>i', '>', 'ki', 'si'])
    ],
    'Replace the `ci` in `ciat` with the Women\'s Script `>` character when it is preceded by one of [eiu].',
  ),
  Rule(
    <Pattern>[RegExp('(?<![eiu])ciat')],
    anywhere,
    <OptionSet>[
      OptionSet('ci', <String>['si', '>i', '>', 'ki'])
    ],
    'Replace the `ci` in `ciat` with `si` when it is not preceded by one of [eiu].',
  ),
  Rule(
    <Pattern>['cing'],
    anywhere,
    <OptionSet>[
      OptionSet('cing', <String>['sing', 'king'])
    ],
    '',
  ),
  Rule(
    <Pattern>[RegExp('ci')],
    anywhere,
    <OptionSet>[
      OptionSet('ci', <String>['si', 'ki', '>'])
    ],
    'Replace `ci` without any special endings with `si`.',
  ),
  Rule(
    <Pattern>[RegExp('cy')],
    anywhere,
    <OptionSet>[
      OptionSet('cy', <String>['sy', 'ky'])
    ],
    'Replace `cy` with `sy`.',
  ),

  // The letter C in other contexts C[^AEHIKLORSTUY\n]
  Rule(
    <Pattern>['cc'],
    anywhere,
    <OptionSet>[
      OptionSet('c', <String>['k', 's'])
    ],
    'Replace the first `c` in `cc` as a `k`, leaving the second one to be processed in the next loop.',
  ),
  Rule(
    <Pattern>['cqu'],
    anywhere,
    <OptionSet>[
      OptionSet('cqu', <String>['kqu', 'k', 'squ'])
    ],
    'Replace `cqu` with `cqu` in most cases, but also give the potential option of just a `k` to handle words like "lacquer."',
  ),
  Rule(
    <Pattern>['cw'],
    anywhere,
    <OptionSet>[
      OptionSet('c', <String>['k', 's'])
    ],
    'Replace the `c` of `cw` with `k`, assuming that the `c` is at the end of syllable.',
  ),
  Rule(
    <Pattern>['cz'],
    anywhereButMiddle,
    <OptionSet>[
      OptionSet('cz', <String>['c', 'kz', 'sz', 'tz'])
    ],
    'Replace `cz` at the start or end of words with the Women\'s Script c letter.',
  ),
  Rule(
    <Pattern>['cz'],
    middleOnly,
    <OptionSet>[
      OptionSet('c', <String>['k', 's', 't'])
    ],
    'Replace `cz` in the middle of a word with `k`, assuming that the `c` is at the end of a syllable.',
  ),
  Rule(
    <Pattern>['c'],
    anywhere,
    <OptionSet>[
      OptionSet('c', <String>['k', 's'])
    ],
    'Replace any `c` which hasn\'t been matched by a previous rule with a `k`, assuming that the `c` is at the end of a syllable.',
  ),
]);
