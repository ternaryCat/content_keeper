module Tags
  class Create < BaseService
    option :user
    option :name

    def call
      valid!

      Tag.create user: user, name: name
    end

    private

    def valid!
      raise Duplicate if Tag.find_by user: user, name: name
      raise ExceedingLimit if user.tags.count >= user.plan.tags
    end
  end
end
