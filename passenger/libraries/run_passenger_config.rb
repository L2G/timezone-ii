# figure out where ruby is.  We have this kind of cumbersome thing
# since rvm may or may not be installed.

class Chef
  class Recipe
    def run_passenger_config *opts
      if File.exists?("/usr/local/bin/rvm")
        return `/usr/local/bin/rvm default exec passenger-config #{opts * ' '}`.chomp
      else
        return "passenger-config #{opts * ' '}"
      end
    end
  end
end
