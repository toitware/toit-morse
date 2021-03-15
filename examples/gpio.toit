// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

/**
This example demonstrates the use of the morse package with an ESP32.
It assumes that pin 23 is connected to an LED (and an appropriate resistor).
*/

import morse
import gpio

// Update the pin here if you use a different one.
LED_PIN ::= 23

main:
  pin := gpio.Pin.out LED_PIN

  10.repeat:
    morse.emit_string
        "hello world"
        --dot_duration= Duration --ms=250
        --on=:  pin.set 1
        --off=: pin.set 0
    sleep (Duration --ms=3000)
