module EOD
  class EODError < StandardError; end
  class BadResponse < StandardError; end
  class MissingAuth < StandardError; end
  class InputError < StandardError; end
end