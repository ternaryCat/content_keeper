module Telegram
  class AdminController < ApplicationController
    def dashboard!
      dashboard
    end

    def debug!
      debug
    end

    def callback_query(data)
      callback_strategy(data.to_sym)&.call
    end

    private

    def callback_strategy(action)
      {
        dashboard: -> { dashboard },
        debug: -> { debug }
      }[action]
    end

    def dashboard
      authorize :admin, :dashboard?

      users_count = User.count
      contents_count = ContentReference.count
      new_users_count = User.where('created_at >= ?', previous_day).count
      new_contents_count = ContentReference.where('created_at >= ?', previous_day).count
      Admins::DashboardAnswer.render self, users_count, contents_count, new_users_count, new_contents_count
    end

    def debug
      authorize :admin, :debug?
      Admins::DebugAnswer.render self, current_authentication
    end

    def previous_day
      1.day.ago.beginning_of_day
    end
  end
end
