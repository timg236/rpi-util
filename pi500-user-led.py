#!/usr/bin/env python3

import gpiod
import time
from gpiod.line import Direction, Value

LINE = 23
with gpiod.request_lines(
    "/dev/gpiochip10",
    consumer="pi500 USER LED example",
    config={
        LINE: gpiod.LineSettings(
            direction=Direction.OUTPUT, output_value=Value.ACTIVE
        )
    },
) as request:
    while True:
        request.set_value(LINE, Value.ACTIVE)
        time.sleep(1)
        request.set_value(LINE, Value.INACTIVE)
        time.sleep(1)
