module ContentReferencesTags
  class BaseService < ::BaseService
    class NotFound < RuntimeError; end

    class NotFoundContent < RuntimeError; end

    class NotFoundTag < RuntimeError; end
  end
end
