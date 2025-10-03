#!/usr/bin/env python3
import sys
import os
import html
import json

def main():
    print("Content-Type: text/html; charset=utf-8")
    print()

    # Read raw POST body
    try:
        content_length = int(os.environ.get("CONTENT_LENGTH", 0))
    except ValueError:
        content_length = 0

    raw_body = sys.stdin.buffer.read(content_length)
    text_body = raw_body.decode("utf-8", errors="replace")

    # If JSON, parse and pretty-print
    content_type = os.environ.get("CONTENT_TYPE", "")
    if content_type.startswith("application/json"):
        try:
            obj = json.loads(text_body)
            pretty = json.dumps(obj, indent=2)
            print(pretty)
        except json.JSONDecodeError:
            # fallback: print raw body if invalid JSON
            print(text_body)
    else:
        # not JSON — just print raw POST body
        print(text_body)

if __name__ == "__main__":
    main()
