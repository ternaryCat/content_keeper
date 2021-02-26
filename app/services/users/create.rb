module Users
  class Create < BaseService
    class Error < RuntimeError; end
    class AlreadyExistsError < RuntimeError; end

    option :provider
    option :uid
    option :first_name, optional: true
    option :last_name, optional: true
    option :username, optional: true
    option :language_code, optional: true

    def call
      raise AlreadyExistsError if Authentication.find_by(uid: uid, provider: provider)

      user = nil
      ActiveRecord::Base.transaction do
        user = User.create
        Authentication.create(authentication_params(user))
      end
      raise Error unless user.persisted?

      user
    end

    private

    def authentication_params(user)
      {
        provider: provider,
        uid: uid,
        user_id: user.id,
        first_name: first_name,
        last_name: last_name,
        username: username,
        language_code: language_code,
        role: :user
      }
    end
  end
end
