# -*- coding: utf-8 -*-
module Epos
  class CodePage
    F1_MAP = {
      "¬"      => "-́",
      "\u0096" => "—",
      "\u0097" => "—",
      "\u0086" => "✝",
      "\u0093" => "“",
      "\u0094" => "”",
      "\u009c" => "œ", # A mistake, should be f6, e.g. "causeur".
    }
  end
end
