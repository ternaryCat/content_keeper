module Telegram
  class BaseAnswer
    # read more at https://github.com/dry-rb/dry-initializer
    extend Dry::Initializer

    param :controller

    class << self
      # Instantiates and calls the service at once
      def render(*args, &block)
        new(*args).render(&block)
      end

      # Accepts both symbolized and stringified attributes
      def new(*args, **kwargs)
        kwargs = args.pop.deep_symbolize_keys if args.last.is_a?(Hash) && kwargs.empty?
        super(*args, **kwargs)
      end
    end
  end
end
