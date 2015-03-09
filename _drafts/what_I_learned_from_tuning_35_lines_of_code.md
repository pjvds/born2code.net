---
layout: post
title: "what I learned from tuning 35 lines of code"
---

The last few weeks I have spending a good part of my freetime on optimizing roughtly 35 lines of code. The result of this effort is a 110x increase in performance and in this post I want to summarize my journey.

# Starting point

{% highlight go %}
func Format(entry tidy.Entry) ([]byte, error) {
    buffer := make([]byte, 0)
 
    term := terminal.TerminalWriter{buffer}
    color := colors[entry.Level]
 
    term.Color(color).Print(entry.Timestamp.Format("15:04:05"))
    term.Print(entry.Level.FixedString())
    term.Print(" [").Print(entry.Module).Print("] ").Reset()
    term.Print(" ").Print(entry.Message)
 
    if len(entry.Fields) > 0 {
        term.Print("\t")
        for key, value := range entry.Fields {
            term.Color(color).Print(" ").Print(key).Print("=").Reset()
            term.Print(value)
        }
    }
 
    term.Print("\n")
 
    _, err := buffer.WriteTo(writer)
    return err
}
```

# final code

{% highlight go %}
package tidy

import (
    "fmt"
    "io"
)

var colors = [][]byte{
    []byte("\033[35m"), // Fatal, magenta
    []byte("\033[31m"), // Error, red
    []byte("\033[33m"), // Warn, yellow
    []byte("\033[32m"), // Notice, green
    []byte("\033[37m"), // Info, white
    []byte("\033[36m"), // Debug, cyan
}

var reset = []byte("\033[0m")
var newline = []byte("\n")
var whitespace = []byte(" ")
var colon = []byte(":")
var split = []byte("=")

type ColoredTextFormatter struct{}

func (this ColoredTextFormatter) FormatTo(writer io.Writer, entry Entry) error {
    buffer := NewBuffer()
    defer buffer.Free()

    buffer.Grow(150)

    color := colors[entry.Level]
    buffer.Write(color)

    hour, minute, second := entry.Timestamp.Clock()
    buffer.WriteTwoDigits(hour)
    buffer.Write(colon)
    buffer.WriteTwoDigits(minute)
    buffer.Write(colon)
    buffer.WriteTwoDigits(second)
    buffer.Write(whitespace)
    buffer.WriteString(chars[entry.Level])
    buffer.WriteString(" ⟨")
    buffer.WriteString(entry.Module.String())
    buffer.WriteString("⟩")
    buffer.WriteString(": ")
    buffer.Write(reset)
    buffer.WriteString(entry.Message)

    if entry.Fields.Any() {
        buffer.Write(color)
        buffer.WriteString("\t→")
        for key, value := range entry.Fields {
            buffer.Write(whitespace)
            buffer.Write(color)
            buffer.WriteString(key)
            buffer.Write(reset)
            buffer.Write(split)

            switch value := value.(type) {
            case string:
                buffer.WriteString(value)
            default:
                buffer.WriteString(fmt.Sprint(value))
            }

        }
    }

    buffer.Write(newline)

    _, err := buffer.WriteTo(writer)
    return err
}
{% endhighlight %}