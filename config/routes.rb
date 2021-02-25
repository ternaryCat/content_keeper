Rails.application.routes.draw do
  telegram_webhook Telegram::WebhookController

  get '/', to: 'welcome#welcome'
end
