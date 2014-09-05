require 'epos'
require 'sinatra'

set :dict, Epos::Dictionary.new(ARGV[0] || ".")
set :bind, '0.0.0.0'

get "/:level/:word/" do
  settings.dict.look_up(params[:word], level: params[:level].to_i, fragment: false)
end
