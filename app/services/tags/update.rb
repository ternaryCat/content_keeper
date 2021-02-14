module Tags
  class Update < BaseService
    param :tag
    option :user
    option :name

    def call
      valid!

      tag.update name: name
    end

    private

    def valid!
      raise NotFound unless tag
      raise Duplicate if Tag.find_by user: user, name: name
    end
  end
end
