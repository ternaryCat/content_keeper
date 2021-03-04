module ContentReferencesTags
  class BaseService < ::BaseService
    class Duplicate < RuntimeError; end

    class NotFoundContent < RuntimeError; end

    class NotFoundTag < RuntimeError; end
  end
end
