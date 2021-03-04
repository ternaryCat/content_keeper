module Tags
  class BaseService < ::BaseService
    class NotFound < RuntimeError; end

    class Duplicate < RuntimeError; end

    class ExceedingLimit < RuntimeError; end
  end
end
