// html_minifier.go
package main

import (
	"bufio"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"regexp"
	"strings"
)

type HTMLMinifier struct {
	RemoveComments    bool
	PreserveWhitespace bool
	RemoveQuotes      bool
}

func NewHTMLMinifier(removeComments, preserveWhitespace, removeQuotes bool) *HTMLMinifier {
	return &HTMLMinifier{
		RemoveComments:    removeComments,
		PreserveWhitespace: preserveWhitespace,
		RemoveQuotes:      removeQuotes,
	}
}

func (m *HTMLMinifier) Minify(html string) string {
	// Remove comments
	if m.RemoveComments {
		re := regexp.MustCompile(`<!--.*?-->`)
		html = re.ReplaceAllString(html, "")
	}

	// Strip lines and collapse spaces
	lines := strings.Split(html, "\n")
	var cleaned []string
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if trimmed != "" || strings.Contains(line, "<") {
			cleaned = append(cleaned, trimmed)
		}
	}
	html = strings.Join(cleaned, "")

	if !m.PreserveWhitespace {
		// Remove spaces between tags
		re := regexp.MustCompile(`>\s+<`)
		html = re.ReplaceAllString(html, "><")
		// Collapse multiple spaces
		re = regexp.MustCompile(` {2,}`)
		html = re.ReplaceAllString(html, " ")
	}

	if m.RemoveQuotes {
		re := regexp.MustCompile(`=\s*"([^"]*)"`)
		html = re.ReplaceAllString(html, `=$1`)
		re = regexp.MustCompile(`=\s*'([^']*)'`)
		html = re.ReplaceAllString(html, `=$1`)
	}

	// Remove multiple newlines
	re := regexp.MustCompile(`\n\s*\n`)
	html = re.ReplaceAllString(html, "\n")
	return strings.TrimSpace(html)
}

func main() {
	var inputFile, outputFile string
	var noComments, preserveWhitespace, removeQuotes bool
	flag.StringVar(&inputFile, "i", "", "Input HTML file (or stdin)")
	flag.StringVar(&outputFile, "o", "", "Output file (or stdout)")
	flag.BoolVar(&noComments, "no-comments", false, "Keep comments")
	flag.BoolVar(&preserveWhitespace, "preserve-whitespace", false, "Preserve whitespace inside text")
	flag.BoolVar(&removeQuotes, "remove-quotes", false, "Remove quotes from simple attributes")
	flag.Parse()

	var content string
	if inputFile != "" {
		data, err := ioutil.ReadFile(inputFile)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		content = string(data)
	} else {
		stat, _ := os.Stdin.Stat()
		if (stat.Mode() & os.ModeCharDevice) == 0 {
			scanner := bufio.NewScanner(os.Stdin)
			var sb strings.Builder
			for scanner.Scan() {
				sb.WriteString(scanner.Text())
				sb.WriteString("\n")
			}
			content = sb.String()
		} else {
			fmt.Fprintln(os.Stderr, "No input provided.")
			os.Exit(1)
		}
	}

	minifier := NewHTMLMinifier(!noComments, preserveWhitespace, removeQuotes)
	minified := minifier.Minify(content)

	if outputFile != "" {
		err := ioutil.WriteFile(outputFile, []byte(minified), 0644)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
	} else {
		fmt.Println(minified)
	}
}
