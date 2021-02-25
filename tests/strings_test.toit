// Copyright (C) 2021 Toitware ApS. All rights reserved.

import morse
import expect show *

main:
  encoded := morse.encode_string "sos"
  expected := [
    morse.DOT, morse.SPACE_SYMBOL, morse.DOT, morse.SPACE_SYMBOL, morse.DOT,
    morse.SPACE_LETTER,
    morse.DASH, morse.SPACE_SYMBOL, morse.DASH, morse.SPACE_SYMBOL, morse.DASH,
    morse.SPACE_LETTER,
    morse.DOT, morse.SPACE_SYMBOL, morse.DOT, morse.SPACE_SYMBOL, morse.DOT,
  ]
  expect_list_equals expected encoded
