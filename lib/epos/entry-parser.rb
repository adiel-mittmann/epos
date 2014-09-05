# -*- coding: utf-8 -*-
module Epos

  class EntryParser

    def parse(text)

      entry = {
        :headword      => nil,
        :n             => nil,
        :trademark     => nil,
        :translation   => nil,
        :pronunciation => nil,
        :language      => nil,
        :first_use     => nil,
        :orthoepy      => nil,
        :variants      => [],
        :old_spelling  => nil,
        :see           => false,
        :tabs          => [],
        :divs          => [],
      }

      div    = nil
      defin  = nil
      either = nil

      text.lines.each do |line|
        code   = line[0]
        suffix = line[1..-1].strip

        case code

        when "*"
          entry[:headword] = suffix
        when ">"
          entry[:see] = true
        when "t"
          entry[:translation] = suffix
        when "p"
          entry[:pronunciation] = suffix
        when "n"
          entry[:n] = suffix.to_i
        when "L"
          entry[:language] = suffix.split("|")
        when "®"
          entry[:trademark] = true
        when "d"
          entry[:first_use] = suffix
        when "o"
          entry[:orthoepy] = suffix
        when "M"
          entry[:variants] = suffix.split("|")
        when "$"
          entry[:old_spelling] = suffix
        when "0"
          entry[:tabs] << {:type => :grammar, :text => suffix}
        when "1"
          entry[:tabs] << {:type => :grammar_usage, :text => suffix}
        when "2"
          entry[:tabs] << {:type => :usage, :text => suffix}
        when "3"
          entry[:tabs] << {:type => :etymology, :text => suffix}
        when "4"
          entry[:tabs] << {:type => :synonyms, :text => suffix}
        when "5"
          entry[:tabs] << {:type => :antonyms, :text => suffix}
        when "6"
          entry[:tabs] << {:type => :collective, :text => suffix}
        when "7"
          entry[:tabs] << {:type => :homonyms, :text => suffix}
        when "8"
          entry[:tabs] << {:type => :paronyms, :text => suffix}
        when "9"
          entry[:tabs] << {:type => :animals, :text => suffix}

        when "B"
          div = {
            :pos        => nil,
            :idiom      => nil,
            :field      => nil,
            :regional   => nil,
            :register   => nil,
            :temporal   => nil,
            :freq       => nil,
            :plural     => nil,
            :symbols    => nil,
            :derivation => nil,
            :defins     => [],
          }
          entry[:divs] << div
          either = div
          defin  = nil
        when "C"
          div[:pos] = suffix.split("|")
        when "#"
          div[:idiom] = suffix
        when "P"
          div[:plural] = suffix
        when "s"
          div[:symbols] = true

        when "A"
          defin = {
            :num        => nil,
            :text       => nil,
            :transty     => nil,
            :examples   => [],
            :note       => nil,
            :derivation => nil,
            :field      => nil,
            :register   => nil,
            :freq       => nil,
            :regional   => nil,
            :temporal   => nil,
            :see        => entry[:see],
          }
          either = defin
          div[:defins] << defin
        when "-"
          defin[:num] = suffix
        when ":"
          defin[:text] = suffix
        when "r"
          defin[:transty] = suffix.split("|")
        when "<"
          defin[:examples] = suffix.split("|")
        when "!"
          defin[:note] = suffix
        when "D"
          either[:derivation] = suffix.split("|")
        when "T"
          either[:field] = suffix.split("|")
        when "U"
          either[:register] = suffix.split("|")
        when "E"
          either[:freq] = suffix.split("|")
        when "R"
          either[:regional] = suffix.split("|")
        when "I"
          either[:temporal] = suffix.split("|")

        when "c"  # hidden, apparently
        when "S"  # unknown
        when "v"  # unknown
        when "\\" # coding error
        else
          raise "#{code}#{suffix}"
        end
      end

      return entry
    end

  end

end
