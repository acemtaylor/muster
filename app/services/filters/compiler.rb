module Filters
  class Compiler
    class UnknownFieldError < StandardError; end
    class UnknownOperatorError < StandardError; end

    SIMPLE_FIELDS = %w[
      first_name last_name email phone_number city state postal_code
      country assessment created_by_method preferred_language
    ].freeze

    def initialize(subject_type: "person")
      @subject_type = subject_type
    end

    def compile(filter_json)
      base_relation.where(build_condition(filter_json))
    end

    private

    def base_relation
      case @subject_type
      when "person" then Person.all
      else
        raise ArgumentError, "Unsupported subject_type: #{@subject_type}"
      end
    end

    def build_condition(node)
      if node.key?("combinator")
        build_group(node)
      else
        build_rule(node)
      end
    end

    def build_group(node)
      combinator = node.fetch("combinator")
      rules = node.fetch("rules")

      sub_relations = rules.map { |rule_node| base_relation.where(build_condition(rule_node)) }

      combined = sub_relations.reduce do |acc, rel|
        case combinator
        when "AND" then acc.and(rel)
        when "OR"  then acc.or(rel)
        else
          raise ArgumentError, "Unknown combinator: #{combinator}"
        end
      end

      combined.where_clause.ast
    end

    def build_rule(rule)
      field = rule.fetch("field")

      case field
      when "custom_property"
        build_custom_property_rule(rule)
      when "geom"
        build_geo_rule(rule)
      when "organization"
        build_organization_rule(rule)
      else
        build_simple_rule(rule)
      end
    end

    def build_simple_rule(rule)
      field = rule.fetch("field")
      operator = rule.fetch("operator")
      value = rule["value"]

      unless SIMPLE_FIELDS.include?(field)
        raise UnknownFieldError, "Unknown or unsupported field: #{field}"
      end

      case operator
      when "eq"
        { field.to_sym => value }
      when "not_eq"
        base_relation.where.not(field => value).where_clause.ast
      when "in"
        { field.to_sym => value }
      when "is_not_null"
        base_relation.where.not(field => nil).where_clause.ast
      when "is_null"
        { field.to_sym => nil }
      when "contains"
        base_relation.where("#{field} ILIKE ?", "%#{value}%").where_clause.ast
      else
        raise UnknownOperatorError, "Unknown operator: #{operator}"
      end
    end

    def build_custom_property_rule(rule)
      key = rule.fetch("key")
      operator = rule.fetch("operator")
      value = rule["value"]

      definition = CustomPropertyDefinition.find_by(key: key)
      raise UnknownFieldError, "Unknown custom property: #{key}" unless definition

      person_ids = CustomPropertyValue.where(definition_id: definition.id)

      person_ids =
        case operator
        when "is_not_null"
          person_ids.where.not(value: nil)
        when "is_null"
          person_ids.where(value: nil)
        when "eq"
          person_ids.where("value = ?", value.to_json)
        when "not_eq"
          person_ids.where.not("value = ?", value.to_json)
        else
          raise UnknownOperatorError, "Unknown operator for custom_property: #{operator}"
        end

      base_relation.where(id: person_ids.select(:person_id)).where_clause.ast
    end

    def build_geo_rule(rule)
      operator = rule.fetch("operator")
      value = rule.fetch("value")

      case operator
      when "within_radius"
        lat = value.fetch("lat")
        lng = value.fetch("lng")
        km = value.fetch("km")

        base_relation
          .where("ST_DWithin(geom, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography, ?)", lng, lat, km * 1000)
          .where_clause.ast
      else
        raise UnknownOperatorError, "Unknown operator for geom: #{operator}"
      end
    end

    def build_organization_rule(rule)
      operator = rule.fetch("operator")
      value = rule.fetch("value")

      case operator
      when "descendant_of"
        org = Organization.find(value)
        org_ids = Organization.where("path <@ ?", org.path).select(:id)
        base_relation.where(organization_id: org_ids).where_clause.ast
      else
        raise UnknownOperatorError, "Unknown operator for organization: #{operator}"
      end
    end
  end
end
