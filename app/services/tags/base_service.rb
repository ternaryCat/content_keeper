module Tags
  class BaseService < ::BaseService
    class NotFound < RuntimeError; end

    class Duplicate < RuntimeError; end
  end
end
