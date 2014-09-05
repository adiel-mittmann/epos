# -*- coding: utf-8 -*-
require 'epos/cp/f1.rb'
require 'epos/cp/f2.rb'
require 'epos/cp/f3.rb'
require 'epos/cp/f4.rb'
require 'epos/cp/f6.rb'
require 'epos/cp/f7.rb'
require 'epos/cp/f8.rb'
require 'epos/cp/f9.rb'
require 'epos/cp/f10.rb'
require 'epos/cp/f11.rb'
require 'epos/cp/f12.rb'
require 'epos/cp/f13.rb'
require 'epos/cp/f16.rb'

module Epos

  class TextParser

    def parse(text)
      @result   = []
      @format   = [{}]
      @fragment = ""
      @cmd      = ""

      s    = :reading_fragment
      code = ""

      text.each_char do |c|

        case s

        when :reading_fragment
          case c 
          when "\\"
            s = :escape_started
          when "{"
            self.flush
            @format << @format.last.clone
          when "}"
            self.flush
            @format.pop if @format.length > 1 # Entry "bum-bum" is broken.
          else
            @fragment << c
          end

        when :escape_started
          case c
          when "\\"
            @fragment << c
            s = :reading_fragment
          when "{"
            @fragment << c
            s = :reading_fragment
          when "'"
            code = ""
            s = :reading_code
          else
            @cmd = c
            s = :reading_command
          end

        when :reading_command
          case c
          when " "
            self.command
            s = :reading_fragment
          when "\\"
            self.command
            s = :escape_started
          when /[a-z0-9]/
            @cmd << c
          when "{"
            self.command
            self.flush
            @format << @format.last.clone
            s = :reading_fragment
          when "}"
            self.command
            self.flush
            @format.pop
            s = :reading_fragment
          else
            self.command
            @fragment << c
            s = :reading_fragment
          end

        when :reading_code
          code << c
          if code.length == 2
            @fragment << [code.to_i(16)].pack("U")
            s = :reading_fragment
          end
        end
      end

      self.command if s == :reading_command
      self.flush

      return @result

    end

    protected

    CODE_PAGES = {
      "f1"  => CodePage::F1_MAP,
      "f2"  => CodePage::F2_MAP,
      "f3"  => CodePage::F3_MAP,
      "f4"  => CodePage::F4_MAP,
      "f6"  => CodePage::F6_MAP,
      "f7"  => CodePage::F7_MAP,
      "f8"  => CodePage::F8_MAP,
      "f9"  => CodePage::F9_MAP,
      "f10" => CodePage::F10_MAP,
      "f11" => CodePage::F11_MAP,
      "f12" => CodePage::F12_MAP,
      "f13" => CodePage::F13_MAP,
      "f16" => CodePage::F16_MAP,
    }

    def convert_encoding(text, f)
      s = ""
      cp = CODE_PAGES[f]
      text.each_char do |c|
        case
        when cp[c]
          s << cp[c]
        when f == "f1" && !(0x80..0xa0).include?(c.ord)
          s << c
        else
          raise "#{f}:#{c}:#{c.ord.to_s(16)}"
        end
      end
      s
    end

    def flush
      format = @format.last

      # This happens *once* ("mico-leão") in all of Houaiss.
      @fragment.upcase! if format["caps"]
      format.delete("caps")

      @fragment = self.convert_encoding(@fragment, format["f"] || "f1")
      format.delete("f")

      @result << [@fragment, format]
      @fragment = ""
    end

    def command
      self.flush if @fragment.length > 0

      case
      when @cmd =~ /f[0-9][0-9]?/ && @cmd != "f5"
        @cmd = "f1" if @cmd == "f0"
        @format.last["f"] = @cmd

      when ["lang1023", "lang1046", "ltrpar", "li100", "sa100", "sb100", "fs20", "fs22", "fs24"].include?(@cmd)
        # what is this i don't even

      when @cmd == "ulnone"     then @format.last.delete("ul")
      when @cmd == "i0"         then @format.last.delete("i")
      when @cmd == "caps0"      then @format.last.delete("caps")
      when @cmd == "strike0"    then @format.last.delete("strike")
      when @cmd == "nosupersub" then @format.last.delete("super")
                                     @format.last.delete("sub")

      when @cmd == "bullet"    then @fragment << "·"
      when @cmd == "lquote"    then @fragment << "‘"
      when @cmd == "rquote"    then @fragment << "’"
      when @cmd == "ldblquote" then @fragment << '“'
      when @cmd == "rdblquote" then @fragment << '”'

      else
        @format.last[@cmd] = true
      end

    end

  end
end
