// Copyright (C) 2021 Toitware ApS. All rights reserved.

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
