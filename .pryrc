require "awesome_print"
AwesomePrint.pry!

begin
  require "hirb"
  require "hirb-unicode"
  extend Hirb::Console
rescue LoadError => e
end
