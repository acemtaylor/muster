module Automations
  class Runner
    def initialize(automation:, person:)
      @automation = automation
      @person = person
    end

    def call
      return unless @automation.active?

      @automation.automation_steps.each do |step|
        run_step(step)
      end
    end

    private

    def run_step(step)
      case step.step_type
      when "update_property"
        run_update_property(step)
      when "add_tag"
        run_add_tag(step)
      when "send_email", "send_sms", "delay"
        Rails.logger.info("[Automations::Runner] Step '#{step.step_type}' not yet implemented — skipping for person##{@person.id}")
      when "decision"
        Rails.logger.info("[Automations::Runner] Decision step not yet implemented — skipping for person##{@person.id}")
      end
    end

    def run_update_property(step)
      field = step.config["field"]
      value = step.config["value"]
      return unless field

      @person.update!(field => value)
    end

    def run_add_tag(step)
      key = step.config["custom_property_key"]
      value = step.config.fetch("value", true)
      return unless key

      definition = CustomPropertyDefinition.find_by(organization: @person.organization, key: key)
      return unless definition

      CustomPropertyValue.find_or_initialize_by(person: @person, definition: definition).update!(value: value)
    end
  end
end
