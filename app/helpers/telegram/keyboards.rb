module Telegram
  module Keyboards
    def default_inline_keyboard
      [[help_button, close_button]]
    end

    def help_keyboard(user)
      [
        [
          button(I18n.t('bot.keyboard.new_content'), 'new_content'),
          button(I18n.t('bot.keyboard.contents'), 'contents')
        ],
        [button(I18n.t('bot.keyboard.new_tag'), 'new_tag'), button(I18n.t('bot.keyboard.tags'), 'tags')],
        *admin_keyboard(user),
        [button(I18n.t('bot.keyboard.plans'), 'plans'), close_button]
      ]
    end

    def help_button
      button(I18n.t('bot.keyboard.help'), 'help')
    end

    def close_button
      button(I18n.t('bot.keyboard.close'), 'close')
    end

    private

    def admin_keyboard(user)
      keyboard = []
      policy = AdminPolicy.new(user, nil)
      keyboard.append button(I18n.t('bot.keyboard.debug'), 'debug') if policy.debug?
      keyboard.append button(I18n.t('bot.keyboard.dashboard'), 'dashboard') if policy.dashboard?
      [keyboard]
    end
  end
end
