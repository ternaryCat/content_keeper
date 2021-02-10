module Telegram
  class UsersController < ApplicationController
    def start!
      ::Users::Create.call params

      Users::StartAnswer.render self
    rescue ::Users::Create::AlreadyExistsError
      Users::StartAlreadyExistsAnswer.render self
    rescue ::Users::Create::Error, KeyError
      Users::StartErrorAnswer.render self
    end

    private

    def params
      from.merge uid: from['id'], provider: :telegram
    end
  end
end
