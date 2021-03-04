module ContentReferences
  class Create < BaseService
    option :authentication
    option :token
    option :name, optional: true

    def call
      raise ExceedingLimit unless valid?

      ContentReference.create authentication: authentication, token: token, name: name
    end

    private

    def valid?
      contents_count < user.plan.contents
    end

    def contents_count
      @contents_count ||= authentication.content_references.count
    end

    def user
      @user ||= authentication.user
    end
  end
end
