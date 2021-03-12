// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

import morse
import expect show *

main:
  encoded := morse.encode_char 's'
  expect_list_equals [morse.DOT, morse.SPACE_SYMBOL, morse.DOT, morse.SPACE_SYMBOL, morse.DOT] encoded

  encoded = morse.encode_char 'o'
  expect_list_equals [morse.DASH, morse.SPACE_SYMBOL, morse.DASH, morse.SPACE_SYMBOL, morse.DASH] encoded

  encoded = morse.encode_char 'O'
  expect_list_equals [morse.DASH, morse.SPACE_SYMBOL, morse.DASH, morse.SPACE_SYMBOL, morse.DASH] encoded
