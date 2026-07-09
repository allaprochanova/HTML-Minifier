// HtmlMinifier.java
import java.io.*;
import java.util.regex.*;

public class HtmlMinifier {
    private boolean removeComments;
    private boolean preserveWhitespace;
    private boolean removeQuotes;

    public HtmlMinifier(boolean removeComments, boolean preserveWhitespace, boolean removeQuotes) {
        this.removeComments = removeComments;
        this.preserveWhitespace = preserveWhitespace;
        this.removeQuotes = removeQuotes;
    }

    public String minify(String html) {
        if (removeComments) {
            html = html.replaceAll("<!--.*?-->", "");
        }

        String[] lines = html.split("\n");
        StringBuilder sb = new StringBuilder();
        for (String line : lines) {
            String trimmed = line.trim();
            if (!trimmed.isEmpty()) {
                sb.append(trimmed);
            }
        }
        html = sb.toString();

        if (!preserveWhitespace) {
            html = html.replaceAll(">\\s+<", "><");
            html = html.replaceAll(" {2,}", " ");
        }

        if (removeQuotes) {
            html = html.replaceAll("=\\s*\"([^\"]*)\"", "=$1");
            html = html.replaceAll("=\\s*'([^']*)'", "=$1");
        }

        html = html.replaceAll("\n\\s*\n", "\n");
        return html.trim();
    }

    public static void main(String[] args) throws IOException {
        String inputFile = null;
        String outputFile = null;
        boolean noComments = false;
        boolean preserveWhitespace = false;
        boolean removeQuotes = false;

        for (int i = 0; i < args.length; i++) {
            if ("--no-comments".equals(args[i])) noComments = true;
            else if ("--preserve-whitespace".equals(args[i])) preserveWhitespace = true;
            else if ("--remove-quotes".equals(args[i])) removeQuotes = true;
            else if ("-o".equals(args[i]) && i+1 < args.length) outputFile = args[++i];
            else if (inputFile == null) inputFile = args[i];
        }

        String content;
        if (inputFile != null) {
            try (BufferedReader reader = new BufferedReader(new FileReader(inputFile))) {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append("\n");
                }
                content = sb.toString();
            }
        } else {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(System.in))) {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append("\n");
                }
                content = sb.toString();
            }
        }

        HtmlMinifier minifier = new HtmlMinifier(!noComments, preserveWhitespace, removeQuotes);
        String minified = minifier.minify(content);

        if (outputFile != null) {
            try (FileWriter fw = new FileWriter(outputFile)) {
                fw.write(minified);
            }
        } else {
            System.out.println(minified);
        }
    }
}
