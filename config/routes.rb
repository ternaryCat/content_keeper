Rails.application.routes.draw do
  telegram_webhook Telegram::WebhookController

  get '/', to: 'welcome#welcome'
  resources :feedbacks, only: %i(index show) do
    member do
      post :reply
    end

    collection do
      get :closed
    end
  end
end
