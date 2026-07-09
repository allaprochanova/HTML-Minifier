# 🗜️ HTML Minifier – Multi‑Language Edition

A fast and efficient **HTML minifier** that strips unnecessary whitespace, comments, and blank lines from HTML files, reducing their size for production use.  
Built in **7 programming languages** – perfect for build pipelines, learning, or integration.

## ✨ Features
- **Remove comments** – strips `<!-- ... -->` blocks.
- **Condense whitespace** – collapses multiple spaces, tabs, and newlines into single spaces (or removes entirely between tags).
- **Preserve required spaces** – keeps spaces inside text nodes and `pre`, `code`, `textarea` tags (optional).
- **Optional attribute minification** – removes quotes around simple attribute values (advanced).
- **Batch mode** – process multiple files from the command line.
- **Interactive CLI** – choose input source and options.

## 🗂 Languages & Files
| Language          | File                  |
|-------------------|-----------------------|
| Python            | `html_minifier.py`    |
| Go                | `html_minifier.go`    |
| JavaScript        | `html_minifier.js`    |
| C#                | `HtmlMinifier.cs`     |
| Java              | `HtmlMinifier.java`   |
| Ruby              | `html_minifier.rb`    |
| Swift             | `html_minifier.swift` |

## 🚀 How to Run
Each file is standalone – run it with the appropriate interpreter/compiler:

| Language | Command |
|----------|---------|
| Python   | `python html_minifier.py [input.html] [-o output.html]` |
| Go       | `go run html_minifier.go [input.html] [output.html]` |
| JavaScript | `node html_minifier.js [input.html] [output.html]` |
| C#       | `dotnet run` (or `csc HtmlMinifier.cs && HtmlMinifier.exe input.html output.html`) |
| Java     | `javac HtmlMinifier.java && java HtmlMinifier input.html output.html` |
| Ruby     | `ruby html_minifier.rb input.html [output.html]` |
| Swift    | `swift html_minifier.swift input.html [output.html]` |

If no input file is given, the program reads from standard input.  
If output is omitted, the result is printed to stdout.

## 📊 Example
**Input HTML:**
```html
<!DOCTYPE html>
<html>
  <head>
    <title> Hello   World </title>
  </head>
  <body>
    <!-- This is a comment -->
    <p>   This is   a   paragraph.   </p>
  </body>
</html>
Minified output:

html
<!DOCTYPE html><html><head><title> Hello World </title></head><body><p>This is a paragraph.</p></body></html>
🔧 Options
–no-comments – keep comments (default: remove).

–preserve-whitespace – do not collapse whitespace inside text.

–remove-quotes – remove quotes from simple attributes (e.g., class=foo).

🤝 Contributing
Add support for inline CSS/JS minification, configurable rules, or streaming – PRs welcome!

📜 License
MIT – use freely.
