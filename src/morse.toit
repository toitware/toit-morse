// Copyright (C) 2021 Toitware ApS. All rights reserved.

ITU_ ::= {
  // The code is encoded as pairs of bits.
  // 01 starts the code any 00 bit pair represents a dot, 11 a dash.
  'a': 0b01_00_11,
  'b': 0b01_11_00_00_00,
  'c': 0b01_11_00_11_00,
  'd': 0b01_11_00_00,
  'e': 0b01_00,
  'f': 0b01_00_00_11_00,
  'g': 0b01_11_11_00,
  'h': 0b01_00_00_00_00,
  'i': 0b01_00_00,
  'j': 0b01_00_11_11_11,
  'k': 0b01_11_00_11,
  'l': 0b01_00_11_00_00,
  'm': 0b01_11_11,
  'n': 0b01_11_00,
  'o': 0b01_11_11_11,
  'p': 0b01_00_11_11_00,
  'q': 0b01_11_11_00_11,
  'r': 0b01_00_11_00,
  's': 0b01_00_00_00,
  't': 0b01_11,
  'u': 0b01_00_00_11,
  'v': 0b01_00_00_00_11,
  'w': 0b01_00_11_11,
  'x': 0b01_11_00_00_11,
  'y': 0b01_11_00_11_11,
  'z': 0b01_11_11_00_00,
  '0': 0b01_11_11_11_11_11,
  '1': 0b01_00_11_11_11_11,
  '2': 0b01_00_00_11_11_11,
  '3': 0b01_00_00_00_11_11,
  '4': 0b01_00_00_00_00_11,
  '5': 0b01_00_00_00_00_00,
  '6': 0b01_11_00_00_00_00,
  '7': 0b01_11_11_00_00_00,
  '8': 0b01_11_11_11_00_00,
  '9': 0b01_11_11_11_11_00,
}

/**
A dot, aka "di", "dit".
The dot duration is used as basic unit of time measurements. All other
  symbols have a duration that is a multiple of the dot duration.
*/
DOT ::= 0
/**
A dash, aka dah.
The dash duration is 3 times the duration of a dot.
*/
DASH ::= 1
/**
The space between two symbols ($DOT or $DASH).
The symbol space is equal to the dot duration.
*/
SPACE_SYMBOL ::= 2
/**
The space between two characters.
Each character in a Morse sequence is followed by a letter-space, which is encoded
  as the absence of any signal, equal to 3 times the dot duration.
*/
SPACE_LETTER ::= 3
/**
The space between two words.
Two words are separated by a word-space which is incoded by the absence of any
  signal for the duration of 7 dots.
*/
SPACE_WORD ::= 4

add_char_to_list list/List c/int -> none:
  encoded := ITU_[c]
  MASK := 0b11
  START_PATTERN ::= 0b01
  DOT_PATTERN ::= 0b00
  DASH_PATTERN ::= 0b11
  shift := 0
  // Shift the mask until we found the start-pattern.
  while (encoded >> shift) & MASK != START_PATTERN:
    shift += 2
    if shift > 16: throw "Didn't find start pattern. Internal error."
  // Skip over the start pattern.
  shift -= 2
  while shift >= 0:
    bits := (encoded >> shift) & MASK
    if bits == DOT_PATTERN:
      list.add DOT
    else:
      assert: bits == DASH_PATTERN
      list.add DASH
    shift -= 2

/**
Converts a character to Morse code.

Returns a list of $DOT (dits), $DASH (dahs).

Throws if the character is not part of the international (ITU) Morse standard.
*/
encode_char c/int -> List:
  result := []
  add_char_to_list result c
  return result

/**
Converts a character to Morse code.

Returns a list of $DOT (dits), $DASH (dahs), $SPACE_LETTER and $SPACE_WORD.
Does not insert $SPACE_SYMBOL spaces.

Throws if the character is not part of the international (ITU) Morse standard.
*/
encode_string str/string -> List:
  result := []
  needs_letter_space := false
  str.do:
    if it == ' ' or it == '\n':
      result.add SPACE_WORD
      needs_letter_space = false
    else:
      if needs_letter_space:
        result.add SPACE_LETTER
      add_char_to_list result it
      needs_letter_space = true
  return result

DASH_DURATION_FACTOR_         ::= 3
SPACE_SYMBOL_DURATION_FACTOR_ ::= 1
SPACE_LETTER_DURATION_FACTOR_ ::= 3
SPACE_WORD_DURATION_FACTOR_   ::= 7

/**
Emits the given symbol, using the $on and $off blocks.

The symbol must be $DOT, $DASH, $SPACE_SYMBOL, $SPACE_LETTER, or $SPACE_WORD.

The given $dot_duration is used as duration of $DOT.
*/
emit_symbol symbol --dot_duration/Duration [--on] [--off]:
  if symbol == DOT:
    on.call
    sleep dot_duration
    off.call
    return
  if symbol == DASH:
    on.call
    sleep dot_duration * DASH_DURATION_FACTOR_
    off.call
    return
  if symbol == SPACE_SYMBOL:
    sleep dot_duration * SPACE_SYMBOL_DURATION_FACTOR_
    return
  if symbol == SPACE_LETTER:
    sleep dot_duration * SPACE_LETTER_DURATION_FACTOR_
    return
  if symbol == SPACE_WORD:
    sleep dot_duration * SPACE_WORD_DURATION_FACTOR_
    return

/**
Emits the given string, using the $on and $off blocks.

The string must only contain the characters of the latin alphabet, spaces,
  or newlines.

The given $dot_duration is used as duration of $DOT.
*/
emit_string str/string --dot_duration/Duration [--on] [--off]:
  needed_space := null
  str.do:
    if it == ' ' or it == '\n':
      needed_space = SPACE_WORD
      continue.do

    symbols := encode_char it
    symbols.do:
      if needed_space != null:
        emit_symbol needed_space --dot_duration=dot_duration --on=on --off=off
      emit_symbol it --dot_duration=dot_duration --on=on --off=off
      needed_space = SPACE_SYMBOL
    needed_space = SPACE_LETTER
