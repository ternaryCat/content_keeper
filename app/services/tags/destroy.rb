module Tags
  class Destroy < BaseService
    param :tag

    def call
      raise NotFound unless tag

      tag.destroy
    end
  end
end
