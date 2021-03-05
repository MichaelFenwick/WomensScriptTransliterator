part of transliteration_rule;

enum Position { start, end, middle }

const Set<Position> startOnly = <Position>{
  Position.start,
};

const Set<Position> middleOnly = <Position>{
  Position.middle,
};

const Set<Position> endOnly = <Position>{
  Position.end,
};

const Set<Position> anywhere = <Position>{
  Position.start,
  Position.middle,
  Position.end,
};

const Set<Position> anywhereButStart = <Position>{
  Position.middle,
  Position.end,
};

const Set<Position> anywhereButMiddle = <Position>{
  Position.start,
  Position.end,
};

const Set<Position> anywhereButEnd = <Position>{
  Position.start,
  Position.middle,
};
