module ContentReferences
  class BaseService < ::BaseService
    class NotFound < RuntimeError; end
    class ExceedingLimit < RuntimeError; end
  end
end
