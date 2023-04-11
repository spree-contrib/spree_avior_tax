module SpreeAviorTax
  VERSION = '0.0.2-dev'.freeze

  module_function

  # Returns the version of the currently loaded SpreeAviorTax as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION
  end
end
