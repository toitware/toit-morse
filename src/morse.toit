// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

/**
A library to emit Morse code.

Encodes characters or string to Morse code. Also provides convenience methods
  that call given blocks `on` and `off` with the correct timing. Developers can
  simply connect those blocks to peripherals (LED, speakers, ...) to emit the
  correct sequence.
*/

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
A space, or absence of signal, that seperates two symbols ($DOT or $DASH).

This space separates two symbols ($DOT and $DASH) within a character.
It has the same duration as a dot.
*/
SPACE_SYMBOL ::= 2

/**
A space, or absence of a signal, that separates two letters.

This space separates two characters (for example 'o' and 'k') within a word.

It has a duration that is 3 times longer than a dot.
*/
SPACE_LETTER ::= 3

/**
A space, or absence of a signal, that separates two words.

It has a duration that is 7 times longer than a dot.
*/
SPACE_WORD ::= 4

DASH_DURATION_FACTOR_ ::= 3
SPACE_SYMBOL_DURATION_FACTOR_   ::= 1
SPACE_LETTER_DURATION_FACTOR_   ::= 3
SPACE_WORD_DURATION_FACTOR_     ::= 7

add_char_to_list list/List c/int -> none:
  if 'A' <= c <= 'Z': c += 'a' - 'A'
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
    if shift != 0: list.add SPACE_SYMBOL
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
Converts a string to Morse code.

Words must be separated by spaces (' ').
Returns a list of $DOT (dits), $DASH (dahs), and spaces ($SPACE_SYMBOL,
  $SPACE_LETTER or $SPACE_WORD).
Throws if the character is not part of the international (ITU) Morse standard.
*/
encode_string str/string -> List:
  result := []
  words := str.split " "
  // Drop empty words (which would mean that there consecutive spaces).
  words.filter --in_place: it != ""
  for i := 0; i < words.size; i++:
    word := words[i]
    if i != 0: result.add SPACE_WORD
    for j := 0; j < word.size; j++:
      c := word[j]
      if j != 0: result.add SPACE_LETTER
      add_char_to_list result c

  return result

/**
Emits the given symbol, using the $on and $off blocks.

The symbol must be $DOT, $DASH, or one of the spaces ($SPACE_SYMBOL,
$SPACE_LETTER or $SPACE_WORD).

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

The string must only contain the characters of the Latin alphabet or spaces.
The given $dot_duration is used as duration of $DOT.
*/
emit_string str/string --dot_duration/Duration [--on] [--off]:
  needed_space := null
  // We don't split the string into words, but iterate over the characters
  // directly. This way we only need a constant amount of memory.
  // The handling of the spaces becomes slightly more tricky, but in return
  // it's possible to emit very large strings from flash.
  str.do:
    if it == ' ' or it == '\n':
      needed_space = SPACE_WORD
      continue.do

    symbols := encode_char it
    symbols.do:
      if needed_space != null:
        emit_symbol needed_space --dot_duration=dot_duration --on=on --off=off
        needed_space = null
      emit_symbol it --dot_duration=dot_duration --on=on --off=off
    needed_space = SPACE_LETTER
