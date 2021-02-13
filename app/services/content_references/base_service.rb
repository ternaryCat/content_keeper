module ContentReferences
  class BaseService < ::BaseService
    class NotFound < RuntimeError; end
  end
end
