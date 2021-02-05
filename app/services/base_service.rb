class BaseService
  # read more at https://github.com/dry-rb/dry-initializer
  extend Dry::Initializer

  class << self
    # Instantiates and calls the service at once
    def call(*args, &block)
      new(*args).call(&block)
    end

    # Accepts both symbolized and stringified attributes
    def new(*args, **kwargs)
      kwargs = args.pop.deep_symbolize_keys if args.last.is_a?(Hash) && kwargs.empty?
      super(*args, **kwargs)
    end
  end
end
