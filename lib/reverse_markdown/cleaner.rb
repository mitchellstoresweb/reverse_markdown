module ReverseMarkdown
  class Cleaner

    def tidy(string)
      result = remove_inner_whitespaces(string)
      result = remove_newlines(result)
      result = remove_leading_newlines(result)
      result = clean_tag_borders(result)
      clean_punctuation_characters(result)
    end

    def remove_newlines(string)
      string.gsub(/\n{3,}/, "\n\n")
    end

    def remove_leading_newlines(string)
      string.gsub(/\A\n+/, '')
    end

    def remove_inner_whitespaces(string)
      string.each_line.inject("") do |memo, line|
        memo + preserve_border_whitespaces(line) do
          line.strip.gsub(/[ \t]{2,}/, ' ')
        end
      end
    end

    def clean_tag_borders(string)
      string.gsub(/\s?\[.*?\]\s?/) do |match|
        preserve_border_whitespaces(match) do
          match.strip.sub('[ ', '[').sub(' ]', ']')
        end
      end
    end

    def clean_punctuation_characters(string)
      string.gsub(/(\*\*|~~|__)\s([\.!\?'"])/, "\\1".strip + "\\2")
    end

    private

    def preserve_border_whitespaces(string, options = {}, &block)
      return string if string =~ /\A\s*\Z/
      default_border = options.fetch(:default_border, '')
      # If the string contains part of a link so the characters [,],(,)
      # then don't add any extra spaces
      default_border = '' if string =~ /[\[\(\]\)]/
      string_start   = present_or_default(string[/\A\s*/], default_border)
      string_end     = present_or_default(string[/\s*\Z/], default_border)
      result         = yield
      string_start + result + string_end
    end

    def present_or_default(string, default)
      if string.nil? || string.empty?
        default
      else
        string
      end
    end

  end
end
