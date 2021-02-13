module ContentReferences
  class Destroy < BaseService
    param :content_reference

    def call
      raise NotFound unless content_reference

      content_reference.destroy
    end
  end
end
