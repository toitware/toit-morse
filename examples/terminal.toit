// Copyright (C) 2021 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import morse

main:
  on  := "●●●●●●●"
  off := "○○○○○○○"

  print ""  // Make sure we have an empty line to go to.

  move_up := "\x1b[;A"
  10.repeat:
    morse.emit_string
        "hello world"
        --dot_duration= Duration --ms=250
        --on=:  print "$move_up$on"
        --off=: print "$move_up$off"
    sleep (Duration --ms=3000)
