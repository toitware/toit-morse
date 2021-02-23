// Copyright (C) 2021 Toitware ApS. All rights reserved.

import morse
import expect show *

main:
  encoded := morse.encode_char 's'
  expect_list_equals [morse.DOT, morse.DOT, morse.DOT] encoded

  encoded = morse.encode_char 'o'
  expect_list_equals [morse.DASH, morse.DASH, morse.DASH] encoded

  encoded = morse.encode_char 'O'
  expect_list_equals [morse.DASH, morse.DASH, morse.DASH] encoded
