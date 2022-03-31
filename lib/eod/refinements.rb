require 'cgi'

module EOD
  module Refinements
    refine String do
      def uri_encode
        CGI.escape(self).gsub('+', '%20')
      end
    end

    refine Array do
      # Convert a params array like [key:value, key:value] to a hash like
      # {key: value, key: value}
      def translate_params
        result = {}
        return result if empty?

        each do |pair|
          key, value = pair.split ':'
          result[key.to_sym] = value
        end

        result
      end
    end
  end
end
