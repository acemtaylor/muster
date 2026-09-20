class EventsController < ApplicationController
  before_action :authenticate_team_member!
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.order(starts_at: :asc)
  end

  def show
    @shifts = @event.event_shifts.order(:starts_at)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.organization = current_team_member.organization

    if @event.save
      redirect_to @event, notice: "Event created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event deleted."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :ends_at, :virtual_url)
  end
end
