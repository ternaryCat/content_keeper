module Telegram
  class WebhookController < Telegram::Bot::UpdatesController
    def self.dispatch(bot, update)
      super
      controllers = Telegram.constants.select { |x| x.to_s.include?('Controller') && x.to_s != name.demodulize }
      controllers.each do |controller|
        Object.const_get('Telegram::' + controller.to_s).dispatch(bot, update)
      end
    end
  end
end
