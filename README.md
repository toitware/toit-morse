# Morse
Functions for International (ITU) Morse code.

Encodes characters or string to Morse code. Also provides convenience methods
that call given blocks `on` and `off` with the correct timing. Developers can
simply connect those blocks to peripherals (LED, speakers, ...) to emit the
correct sequence.

Note that this package only supports emitting Morse.

## Usage
A simple usage example.

``` toit
import morse

main:
  morse.emit_string "hello"
      --dot_duration=Duration --ms=250
      --on=:  print "on"
      --off=: print "off"
```

See the `examples` folder for more examples.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/toitware/toit-morse/issues
