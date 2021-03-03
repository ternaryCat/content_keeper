module Telegram
  class BaseAnswer
    # read more at https://github.com/dry-rb/dry-initializer
    extend Dry::Initializer
    include Keyboards

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
      controller.answer_callback_query nil if controller.payload['data'].present?
    rescue ::Telegram::Bot::Error
      controller.respond_with :message, text: I18n.t('bot.error'), reply_markup: { inline_keyboard: error_keyboard }
    end

    protected

    def answer(text, reply_markup, edit_options = [])
      params = { text: text, reply_markup: reply_markup }
      return controller.respond_with :message, params unless mode == 'edit'

      edit_options.each { |edit_option| controller.edit_message edit_option, params.slice(edit_option) }
    rescue RuntimeError
      controller.respond_with :message, params
    end

    def button(text, callback_name, **options)
      params = options.compact.to_a.join(':') if options.present?
      callback_data = [callback_name, params].compact.join('-')

      { text: text, callback_data: callback_data }
    end

    def current_user
      controller.current_user
    end

    private

    def error_keyboard
      [[button(I18n.t('bot.keyboard.feedback'), 'feedback'), close_button]]
    end
  end
end
