module ContentReferencesTags
  class Detach < BaseService
    param :content_reference
    param :tag

    def call
      valid!

      content_references_tag.destroy
    end

    private

    def valid!
      raise NotFound unless content_references_tag
      raise NotFoundContent unless content_reference
      raise NotFoundTag unless tag
    end

    def content_references_tag
      @content_references_tag ||= ContentReferencesTag.find_by content_reference: content_reference, tag: tag
    end
  end
end
