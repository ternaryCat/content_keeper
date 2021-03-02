module Telegram
  class AdminController < ApplicationController
    def dashboard!
      authorize :admin, :dashboard?

      users_count = User.count
      contents_count = ContentReference.count
      new_users_count = User.where('created_at >= ?', previous_day).count
      new_contents_count = ContentReference.where('created_at >= ?', previous_day).count
      Admins::DashboardAnswer.render self, users_count, contents_count, new_users_count, new_contents_count
    end

    private

    def previous_day
      1.day.ago.beginning_of_day
    end
  end
end
