// html_minifier.swift
import Foundation

class HTMLMinifier {
    var removeComments: Bool
    var preserveWhitespace: Bool
    var removeQuotes: Bool

    init(removeComments: Bool = true, preserveWhitespace: Bool = false, removeQuotes: Bool = false) {
        self.removeComments = removeComments
        self.preserveWhitespace = preserveWhitespace
        self.removeQuotes = removeQuotes
    }

    func minify(_ html: String) -> String {
        var result = html

        if removeComments {
            let regex = try! NSRegularExpression(pattern: "<!--.*?-->", options: .dotMatchesLineSeparators)
            result = regex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "")
        }

        let lines = result.components(separatedBy: .newlines)
        let trimmedLines = lines.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        result = trimmedLines.joined()

        if !preserveWhitespace {
            let regex = try! NSRegularExpression(pattern: ">\\s+<")
            result = regex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "><")
            let regex2 = try! NSRegularExpression(pattern: " {2,}")
            result = regex2.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: " ")
        }

        if removeQuotes {
            let regex = try! NSRegularExpression(pattern: "=\\s*\"([^\"]*)\"")
            result = regex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "=$1")
            let regex2 = try! NSRegularExpression(pattern: "=\\s*'([^']*)'")
            result = regex2.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "=$1")
        }

        let regex = try! NSRegularExpression(pattern: "\n\\s*\n")
        result = regex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "\n")
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

func main() {
    let args = CommandLine.arguments.dropFirst()
    var inputFile: String? = nil
    var outputFile: String? = nil
    var noComments = false
    var preserveWhitespace = false
    var removeQuotes = false

    var i = 0
    let argsArray = Array(args)
    while i < argsArray.count {
        switch argsArray[i] {
        case "--no-comments": noComments = true
        case "--preserve-whitespace": preserveWhitespace = true
        case "--remove-quotes": removeQuotes = true
        case "-o": 
            if i+1 < argsArray.count { outputFile = argsArray[i+1]; i+=1 }
        default:
            if inputFile == nil { inputFile = argsArray[i] }
        }
        i+=1
    }

    let content: String
    if let input = inputFile {
        guard let data = try? String(contentsOfFile: input, encoding: .utf8) else {
            print("Error reading file", to: &stderr)
            exit(1)
        }
        content = data
    } else {
        content = FileHandle.standardInput.readDataToEndOfFile().toString() ?? ""
    }

    let minifier = HTMLMinifier(
        removeComments: !noComments,
        preserveWhitespace: preserveWhitespace,
        removeQuotes: removeQuotes
    )
    let minified = minifier.minify(content)

    if let output = outputFile {
        try? minified.write(toFile: output, atomically: true, encoding: .utf8)
    } else {
        print(minified)
    }
}

extension FileHandle {
    func readDataToEndOfFile() -> Data {
        let data = self.availableData
        if #available(macOS 10.15, *) {
            // For newer macOS, we can use the new API
            return self.availableData
        } else {
            return data
        }
    }
}

extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}

main()
