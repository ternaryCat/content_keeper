module Users
  class ActivatePlan < BaseService
    class Error < RuntimeError; end

    param :user
    param :plan_type

    def call
      raise Error unless valid?

      Metric.create title: "activate_plan_#{plan_type}", user: user
    end

    private

    def valid?
      user && PLANS[plan_type]
    end
  end
end