module ContentReferences
  class BaseService < ::BaseService
    class NotFound < RuntimeError; end
    class NotFoundTag < RuntimeError; end
  end
end
