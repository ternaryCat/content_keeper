module Telegram
  PAGE_SIZE = 5
end

Telegram.bots_config = {
  default: ENV['TELEGRAM_TOKEN']
}

if ENV['REDIS_URL']
  Rails.application.config.telegram_updates_controller.session_store = :redis_cache_store, {
    url: ENV['REDIS_URL'],
    expires_in: 1.week
  }
  return
end

Rails.application.config.telegram_updates_controller.session_store = :file_store, './storage'
