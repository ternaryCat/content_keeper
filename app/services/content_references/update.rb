module ContentReferences
  class Update < BaseService
    param :content_reference
    option :token, optional: true
    option :name, optional: true

    def call
      raise NotFound unless content_reference

      content_reference.update params
    end

    private

    def params
      { token: token, name: name }.compact
    end
  end
end
