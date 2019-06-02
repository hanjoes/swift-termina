[![Build Status](https://travis-ci.org/hanjoes/Termbo.svg?branch=master)](https://travis-ci.org/hanjoes/Termbo)

# Termbo

Terminal "character-based" rendering, driven by ANSI escape sequences. This library is free of Foundation.

# Usage


## 
``` swift
var t = Termbo(width: 1, height: 1)
let lines = ["|", "\\", "-", "/"]
for i in 1 ... 100 {
    t.render(bitmap: [lines[i % lines.count]], to: stdout)
    usleep(10000)
}
t.clear(stdout) // use "t.end()" if you want to keep the rendered content
```


# Demo

![Quick Demo](./demo.gif)