def fixture(file)
  File.new(File.expand_path('../fixtures', __dir__) + '/' + file)
end
