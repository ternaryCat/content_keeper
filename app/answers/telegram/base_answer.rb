module Telegram
  class BaseAnswer
    # read more at https://github.com/dry-rb/dry-initializer
    extend Dry::Initializer

    param :controller
    option :mode, optional: true

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

    def render
      controller.answer_callback_query nil
    rescue ::Telegram::Bot::Error
    end

    protected

    def button(text, callback_name, **options)
      params = options.compact.to_a.join(':') if options.present?
      callback_data = [callback_name, params].compact.join('-')

      { text: text, callback_data: callback_data }
    end
  end
end
