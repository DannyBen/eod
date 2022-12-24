module EOD
  class EODError < StandardError; end
  class BadResponse < EODError; end
  class MissingAuth < EODError; end
  class InputError < EODError; end
end
