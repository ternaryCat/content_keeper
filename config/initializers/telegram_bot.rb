module Telegram
  PAGE_SIZE = 5
end

Telegram.bots_config = {
  default: ENV['TELEGRAM_TOKEN']
}
