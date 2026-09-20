class DashboardController < ApplicationController
  before_action :authenticate_team_member!

  def index
    @person_count = Person.count
    @upcoming_events = Event.where("starts_at > ?", Time.current).order(:starts_at).limit(5)
    @active_memberships = Membership.where(status: "active").count
  end
end
