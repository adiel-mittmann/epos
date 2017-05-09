# -*- coding: utf-8 -*-
require 'epos/indexed-data-file.rb'
require 'epos/html-formatter.rb'
require 'epos/entry-parser.rb'

module Epos
  class Dictionary

    def initialize(path)
      @idf1 = Epos::IndexedDataFile.new(File.join(path, "deah002.dhn"), File.join(path, "deah001.dhn"))
      @idf2 = Epos::IndexedDataFile.new(File.join(path, "deah008.dhn"), File.join(path, "deah007.dhn"))

      @fmt1 = Epos::HtmlFormatter.new(unmarked: false)
      @fmt2 = Epos::HtmlFormatter.new(unmarked: true)

      @entry_parser = Epos::EntryParser.new

      @fuzzy = {}

      (@idf1.keys + @idf2.keys).each do |key|
        simple = simplify(key)
        if @fuzzy.has_key?(simple)
          @fuzzy[simple] << key
        else
          @fuzzy[simple] = [key]
        end
      end

      @fuzzy.each_value do |value|
        value.sort!.uniq!
      end
    end

    def look_up(word, level: 1, fragment: false)
      html        = ""
      simple_word = simplify(word)
      used        = {}

      if level == 0
        html << look_up_and_format(word)
        used[word] = true
      end

      if level == 1
        (@fuzzy[simple_word] || []).each do |actual|
          if !used[actual]
            html << look_up_and_format(actual)
            used[actual] = true
          end
        end
      end

      if level == 2
        @fuzzy.each do |simple, words|
          if simple.include?(simple_word)
            words.each do |actual|
              if !used[actual]
                html << look_up_and_format(actual)
                used[actual] = true
              end
            end
          end
        end
      end

      if level == 4
        regexp = Regexp.new(word)
        (@idf1.keys + @idf2.keys).each do |actual|
          next if used[actual]
          if actual =~ regexp
            html << look_up_and_format(actual)
            used[actual] = true
          end
        end
      end

      if !fragment
        if html.length == 0
          html = "<i>No results were found for your query.</i>"
        end
        html = %Q{
<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
    <title>Epos</title>
    <style type='text/css'>#{self.style}</style>
  </head>
  <body>
    #{html}
  </body>
</html>
}
      end

      return html
    end

    def style
      @fmt1.style
    end

    def look_up_and_format(word)
      s = ""
      s << @idf1.look_up(word).map{|text| @fmt1.format(@entry_parser.parse(text))}.join
      s << @idf2.look_up(word).map{|text| @fmt2.format(@entry_parser.parse(text))}.join
      return s
    end

    def simplify(s)
      s.tr("áéíóúâêôãõàüçÁÉÍÓÚÂÊÔÃÕÀÜÇ", "aeiouaeoaoaucaeiouaeoaoauc").downcase.gsub(/[ \-\\(\\)]/, "")
    end

  end
end
