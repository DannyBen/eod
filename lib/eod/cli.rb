require 'mister_bin'
require 'eod/command'

module EOD
  class CLI
    def self.runner
      MisterBin::Runner.new handler: Command
    end
  end
end
