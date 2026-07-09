// HtmlMinifier.cs
using System;
using System.IO;
using System.Text.RegularExpressions;

class HtmlMinifier
{
    private bool RemoveComments { get; set; }
    private bool PreserveWhitespace { get; set; }
    private bool RemoveQuotes { get; set; }

    public HtmlMinifier(bool removeComments = true, bool preserveWhitespace = false, bool removeQuotes = false)
    {
        RemoveComments = removeComments;
        PreserveWhitespace = preserveWhitespace;
        RemoveQuotes = removeQuotes;
    }

    public string Minify(string html)
    {
        if (RemoveComments)
            html = Regex.Replace(html, @"<!--.*?-->", "", RegexOptions.Singleline);

        var lines = html.Split('\n');
        var sb = new System.Text.StringBuilder();
        foreach (var line in lines)
        {
            string trimmed = line.Trim();
            if (!string.IsNullOrEmpty(trimmed))
                sb.Append(trimmed);
        }
        html = sb.ToString();

        if (!PreserveWhitespace)
        {
            html = Regex.Replace(html, @">\s+<", "><");
            html = Regex.Replace(html, @" {2,}", " ");
        }

        if (RemoveQuotes)
        {
            html = Regex.Replace(html, @"=\s*""([^""]*)""", "=$1");
            html = Regex.Replace(html, @"=\s*'([^']*)'", "=$1");
        }

        html = Regex.Replace(html, @"\n\s*\n", "\n");
        return html.Trim();
    }

    static void Main(string[] args)
    {
        string inputFile = null;
        string outputFile = null;
        bool noComments = false;
        bool preserveWhitespace = false;
        bool removeQuotes = false;

        for (int i = 0; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--no-comments": noComments = true; break;
                case "--preserve-whitespace": preserveWhitespace = true; break;
                case "--remove-quotes": removeQuotes = true; break;
                case "-o": outputFile = args[++i]; break;
                default: if (inputFile == null) inputFile = args[i]; break;
            }
        }

        string content;
        if (inputFile != null)
        {
            content = File.ReadAllText(inputFile);
        }
        else
        {
            using (var reader = new StreamReader(Console.OpenStandardInput()))
            {
                content = reader.ReadToEnd();
            }
        }

        var minifier = new HtmlMinifier(!noComments, preserveWhitespace, removeQuotes);
        string minified = minifier.Minify(content);

        if (outputFile != null)
            File.WriteAllText(outputFile, minified);
        else
            Console.WriteLine(minified);
    }
}
