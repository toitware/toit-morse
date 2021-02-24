// Copyright (C) 2021 Toitware ApS. All rights reserved.

/**
This example demonstrates a simple conversion from strings to Morse code.
*/

import morse
import gpio

main:
  symbols := morse.encode_string "hello world"
  out_symbols := ""
  out_phonetic := ""
  needs_dash := false
  symbols.do:
    if it == morse.DOT or it == morse.DASH:
      out_symbols += it == morse.DOT ? "." : "-"
      if needs_dash: out_phonetic += "-"
      out_phonetic += it == morse.DOT ? "di" : "dah"
      needs_dash = true
    else:
      if out_phonetic.ends_with "di":
        out_phonetic += "t"
      out_symbols += " "
      out_phonetic += " "
      if it == morse.SPACE_WORD:
        out_symbols += "   "
        out_phonetic += "   "
      needs_dash = false

  if out_phonetic.ends_with "di":
    out_phonetic += "t"

  print out_symbols
  print out_phonetic
