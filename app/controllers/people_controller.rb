class PeopleController < ApplicationController
  before_action :authenticate_team_member!
  before_action :set_person, only: [ :show, :edit, :update, :destroy ]

  def index
    @people = Person.order(created_at: :desc).limit(50)
  end

  def show
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    @person.organization = current_team_member.organization
    @person.created_by_method = "dashboard"

    if @person.save
      redirect_to @person, notice: "Person created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @person.update(person_params)
      redirect_to @person, notice: "Person updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy
    redirect_to people_path, notice: "Person deleted."
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(
      :first_name, :last_name, :email, :phone_number, :secondary_phone,
      :address_1, :address_2, :city, :state, :postal_code, :country,
      :date_of_birth, :assessment, :preferred_language
    )
  end
end
