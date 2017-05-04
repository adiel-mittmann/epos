# -*- coding: utf-8 -*-
require 'slim'
require 'epos/text-parser.rb'

module Epos

  class HtmlFormatter

    def initialize(unmarked: false, compact: false)
      @unmarked     = unmarked
      @string_index = compact ? -2 : -1
      @parser       = TextParser.new
      @html_base    = File.join(File.dirname(__FILE__), "html")

      load_templates()
    end

    def format(entry)
      render(:entry, entry)
    end

    def style
      File.read(File.join(@html_base, "style.css"))
    end

    protected

    def load_templates
      slim      = Tilt["slim"]

      @templates = [:extra_tab, :symbols_tab, :idioms_tab, :senses_tab, :defins, :defin_body, :attrs, :headword, :entry]
      @templates = @templates.map{|sym| [sym, slim.new(File.join(@html_base, sym.to_s.gsub(/_/, "-") + ".slim"), :default_encoding => 'utf-8')]}
      @templates = Hash[@templates]
    end

    def render(item, data)
      @templates[item].render(self, :data => data)
    end

    def render_fragment(fragment, format)
      tags = format.keys.map{|name| FORMATS[name]}
      raise if tags.index(nil)

      open  = tags        .map{|tag| "<"  + tag[:name] + (tag[:style] ? " style='#{tag[:style]}'" : "") + ">"}.join
      close = tags.reverse.map{|tag| "</" + tag[:name]                                                  + ">"}.join

      return open + fragment + close
    end
     
    def render_text(text)
      @parser.parse(text).map{|fragment, format| render_fragment(fragment, format)}.join
    end

    FORMATS = {
      "i"      => {:name => "i"},
      "b"      => {:name => "b"},
      "super"  => {:name => "sup"},
      "sub"    => {:name => "sub"},
      "ul"     => {:name => "span", :style => "text-decoration: underline;"},
      "f5"     => {:name => "span", :style => "font-variant: small-caps;"},
      "strike" => {:name => "span", :style => "text-decoration: line-through;"},
    }

    ATTRS1 = {
      :field         => "rubrica",
      :regional      => "regionalismo",
      :register      => "uso",
      :temporal      => "diacronismo",
      :freq          => "estatística",
      :derivation    => "derivação",
    }
    ATTRS2 = {
      :note          => nil,
    }
    ATTRS3 = {
      :transty       => nil,
    }
    ATTRS4 = {
      :old_spelling  => "forma antiga",
      :trademark     => "marca registrada",
      :language      => "língua",
      :translation   => "tradução",
      :pronunciation => "pronúncia",
      :first_use     => "datação",
      :orthoepy      => "ortoépia",
    }
    ATTRS5 = {
      :plural        => "plural",
    }

    TABS = {
      :senses        => "acepções",
      :idioms        => "locuções",
      :symbols       => "símbolos e abreviações",
      :grammar       => "gramática",
      :grammar_usage => "gramática e uso",
      :usage         => "uso",
      :etymology     => "etimologia",
      :synonyms      => "sinônimos",
      :antonyms      => "antônimos",
      :collective    => "coletivos",
      :homonyms      => "homônimos",
      :paronyms      => "parônimos",
      :animals       => "vozes de animais",
    }

    IDIOM_AUX_MAP = {"@" => "ou", "#" => ","}

  end
end
