// html_minifier.js
const fs = require('fs');
const readline = require('readline');

class HTMLMinifier {
    constructor(options = {}) {
        this.removeComments = options.removeComments !== false;
        this.preserveWhitespace = options.preserveWhitespace || false;
        this.removeQuotes = options.removeQuotes || false;
    }

    minify(html) {
        // Remove comments
        if (this.removeComments) {
            html = html.replace(/<!--[\s\S]*?-->/g, '');
        }

        // Remove leading/trailing whitespace from lines and join
        const lines = html.split('\n').map(line => line.trim()).filter(line => line !== '');
        html = lines.join('');

        if (!this.preserveWhitespace) {
            // Remove spaces between tags
            html = html.replace(/>\s+</g, '><');
            // Collapse multiple spaces
            html = html.replace(/ {2,}/g, ' ');
        }

        if (this.removeQuotes) {
            html = html.replace(/=\s*"([^"]*)"/g, '=$1');
            html = html.replace(/=\s*'([^']*)'/g, '=$1');
        }

        // Remove extra newlines
        html = html.replace(/\n\s*\n/g, '\n');
        return html.trim();
    }
}

function readStdin() {
    return new Promise((resolve) => {
        const rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout,
            terminal: false
        });
        let data = '';
        rl.on('line', (line) => { data += line + '\n'; });
        rl.on('close', () => { resolve(data); });
    });
}

async function main() {
    const args = process.argv.slice(2);
    let inputFile = null;
    let outputFile = null;
    let noComments = false;
    let preserveWhitespace = false;
    let removeQuotes = false;

    for (let i = 0; i < args.length; i++) {
        if (args[i] === '--no-comments') noComments = true;
        else if (args[i] === '--preserve-whitespace') preserveWhitespace = true;
        else if (args[i] === '--remove-quotes') removeQuotes = true;
        else if (args[i] === '-o') { outputFile = args[++i]; }
        else if (!inputFile) inputFile = args[i];
    }

    let content;
    if (inputFile) {
        content = fs.readFileSync(inputFile, 'utf8');
    } else {
        content = await readStdin();
    }

    const minifier = new HTMLMinifier({
        removeComments: !noComments,
        preserveWhitespace,
        removeQuotes
    });
    const minified = minifier.minify(content);

    if (outputFile) {
        fs.writeFileSync(outputFile, minified, 'utf8');
    } else {
        console.log(minified);
    }
}

main().catch(console.error);
