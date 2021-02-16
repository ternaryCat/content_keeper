module ContentReferences
  class AttachTag < BaseService
    class Duplicate < RuntimeError; end

    param :content_reference
    param :tag

    def call
      valid!

      ContentReferencesTag.create content_reference: content_reference, tag: tag
    end

    private

    def valid!
      raise NotFound unless content_reference
      raise NotFoundTag unless tag
      raise Duplicate if ContentReferencesTag.find_by content_reference: content_reference, tag: tag
    end
  end
end
