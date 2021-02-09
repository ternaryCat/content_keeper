module ContentReferences
  class Create < BaseService
    option :authentication
    option :token
    option :name, optional: true

    def call
      ContentReference.create authentication: authentication, token: token, name: name
    end
  end
end
