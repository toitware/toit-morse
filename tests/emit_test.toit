// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

import morse
import expect show *

main:
  actual := []
  dot_duration := Duration --ms=10
  start_time := Time.now
  morse.emit_string "he ll o"
      --dot_duration=dot_duration
      --on=:  actual.add [1, Time.now]
      --off=: actual.add [0, Time.now]

  // 'h': di-di-di-dit   (4)
  // 'e': dit            (1)
  // 'l': di-dah-di-dit  (4)
  // 'o': dah-dah-dah    (3)
  expect_equals
      (4 + 1 + 4 + 4 + 3) * 2  // One for 'on', one for 'off'.
      actual.size

  dash_duration := dot_duration * 3
  symbol_space_duration := dot_duration
  letter_space_duration := dot_duration * 3
  word_space_duration := dot_duration * 7

  expected_durations := [
    Duration.ZERO,
    // 'h':
    dot_duration, symbol_space_duration,
    dot_duration, symbol_space_duration,
    dot_duration, symbol_space_duration,
    dot_duration, letter_space_duration,
    // 'e':
    dot_duration, word_space_duration,
    // 'l':
    dot_duration,  symbol_space_duration,
    dash_duration, symbol_space_duration,
    dot_duration,  symbol_space_duration,
    dot_duration,  letter_space_duration,
    // 'l':
    dot_duration,  symbol_space_duration,
    dash_duration, symbol_space_duration,
    dot_duration,  symbol_space_duration,
    dot_duration,  word_space_duration,
    // 'o':
    dash_duration, symbol_space_duration,
    dash_duration, symbol_space_duration,
    dash_duration
  ]

  last_time := start_time
  expected_on_off := 1
  for i := 0; i < actual.size; i++:
    this_on_off := actual[i][0]
    expect_equals expected_on_off this_on_off
    expected_on_off = this_on_off == 1 ? 0 : 1

    this_time /Time := actual[i][1]
    duration := last_time.to this_time
    expected := expected_durations[i]
    diff /Duration := duration - expected
    // Should never trigger earlier.
    expect diff >= Duration.ZERO
    // We allow up to half a dot-duration of being too late.
    expect diff < (dot_duration / 2)

    last_time = this_time
