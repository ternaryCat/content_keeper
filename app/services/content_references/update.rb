module ContentReferences
  class Update < BaseService
    class Error < RuntimeError; end

    param :content_reference
    option :token, optional: true
    option :name, optional: true

    def call
      raise Error unless content_reference

      content_reference.update params
    end

    def params
      { token: token, name: name }.compact
    end
  end
end
