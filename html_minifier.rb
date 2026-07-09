# html_minifier.rb
class HTMLMinifier
  def initialize(remove_comments: true, preserve_whitespace: false, remove_quotes: false)
    @remove_comments = remove_comments
    @preserve_whitespace = preserve_whitespace
    @remove_quotes = remove_quotes
  end

  def minify(html)
    html = html.gsub(/<!--.*?-->/m, '') if @remove_comments

    lines = html.lines.map(&:strip).reject(&:empty?)
    html = lines.join

    unless @preserve_whitespace
      html.gsub!(/>\s+</, '><')
      html.gsub!(/ {2,}/, ' ')
    end

    if @remove_quotes
      html.gsub!(/=\s*"([^"]*)"/, '=\1')
      html.gsub!(/=\s*'([^']*)'/, '=\1')
    end

    html.gsub!(/\n\s*\n/, "\n")
    html.strip
  end
end

def main
  input_file = nil
  output_file = nil
  no_comments = false
  preserve_whitespace = false
  remove_quotes = false

  args = ARGV
  until args.empty?
    arg = args.shift
    case arg
    when '--no-comments' then no_comments = true
    when '--preserve-whitespace' then preserve_whitespace = true
    when '--remove-quotes' then remove_quotes = true
    when '-o' then output_file = args.shift
    else input_file = arg
    end
  end

  if input_file
    content = File.read(input_file)
  else
    content = $stdin.read
  end

  minifier = HTMLMinifier.new(
    remove_comments: !no_comments,
    preserve_whitespace: preserve_whitespace,
    remove_quotes: remove_quotes
  )
  minified = minifier.minify(content)

  if output_file
    File.write(output_file, minified)
  else
    puts minified
  end
end

main if __FILE__ == $0
