
---

# 💻 Code Implementations

## 1. Python (`html_minifier.py`)

```python
# html_minifier.py
import re
import sys
import argparse

class HTMLMinifier:
    def __init__(self, remove_comments=True, preserve_whitespace=False, remove_quotes=False):
        self.remove_comments = remove_comments
        self.preserve_whitespace = preserve_whitespace
        self.remove_quotes = remove_quotes

    def minify(self, html):
        # Remove comments
        if self.remove_comments:
            html = re.sub(r'<!--.*?-->', '', html, flags=re.DOTALL)

        # Remove leading/trailing whitespace on each line
        lines = html.splitlines()
        html = ' '.join(line.strip() for line in lines)

        # Collapse multiple spaces
        if not self.preserve_whitespace:
            # Remove spaces between tags (but keep at least one space if needed)
            html = re.sub(r'>\s+<', '><', html)
            # Collapse multiple spaces inside text (but keep single spaces)
            html = re.sub(r' {2,}', ' ', html)
            # Remove spaces around attributes? Skip for simplicity.

        # Remove quotes from simple attributes (optional)
        if self.remove_quotes:
            html = re.sub(r'=\s*"([^"]*)"', r'=\1', html)
            html = re.sub(r"=\s*'([^']*)'", r'=\1', html)

        # Remove empty lines
        html = re.sub(r'\n\s*\n', '\n', html)
        return html.strip()

def main():
    parser = argparse.ArgumentParser(description='HTML Minifier')
    parser.add_argument('input', nargs='?', help='Input HTML file (or stdin)')
    parser.add_argument('-o', '--output', help='Output file (or stdout)')
    parser.add_argument('--no-comments', action='store_true', help='Keep comments')
    parser.add_argument('--preserve-whitespace', action='store_true', help='Preserve whitespace inside text')
    parser.add_argument('--remove-quotes', action='store_true', help='Remove quotes from simple attributes')
    args = parser.parse_args()

    if args.input:
        with open(args.input, 'r', encoding='utf-8') as f:
            content = f.read()
    else:
        content = sys.stdin.read()

    minifier = HTMLMinifier(
        remove_comments=not args.no_comments,
        preserve_whitespace=args.preserve_whitespace,
        remove_quotes=args.remove_quotes
    )
    minified = minifier.minify(content)

    if args.output:
        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(minified)
    else:
        print(minified)

if __name__ == '__main__':
    main()
