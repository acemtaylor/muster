module Forms
  class SubmissionProcessor
    def initialize(page:, answers:)
      @page = page
      @answers = answers
    end

    def call
      person = find_or_create_person

      FormSubmission.create!(
        page: @page,
        person: person,
        answers: @answers
      )
    end

    private

    def find_or_create_person
      email = @answers["email"]
      return nil if email.blank?

      existing = Person.where(organization: @page.organization, email: email).order(:created_at).last
      return existing if existing

      Person.create!(
        organization: @page.organization,
        first_name: @answers["first_name"],
        last_name: @answers["last_name"],
        email: email,
        phone_number: @answers["phone_number"],
        created_by_method: "web_form"
      )
    end
  end
end
