// Copyright (C) 2021 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the TESTS_LICENSE file.

import morse
import expect show *

main:
  encoded := morse.encode_char 's'
  expect_list_equals [morse.DOT, morse.SPACE_SYMBOL, morse.DOT, morse.SPACE_SYMBOL, morse.DOT] encoded

  encoded = morse.encode_char 'o'
  expect_list_equals [morse.DASH, morse.SPACE_SYMBOL, morse.DASH, morse.SPACE_SYMBOL, morse.DASH] encoded

  encoded = morse.encode_char 'O'
  expect_list_equals [morse.DASH, morse.SPACE_SYMBOL, morse.DASH, morse.SPACE_SYMBOL, morse.DASH] encoded
