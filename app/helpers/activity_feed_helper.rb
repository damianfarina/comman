module ActivityFeedHelper
  def format_activity_value(model_name, attribute_name, value)
    if value.blank? && value != false
      return nil
    end

    model_class = model_name.safe_constantize

    if model_class && model_class.respond_to?(:defined_enums) && model_class.defined_enums.key?(attribute_name.to_s) && value.present?
      i18n_key = model_class.model_name.i18n_key
      return I18n.t(
        "activerecord.attributes.#{i18n_key}.#{attribute_name}_values.#{value}",
        default: value.to_s,
      )
    end

    case value
    when TrueClass
      t("paper_trail.boolean_true")
    when FalseClass
      t("paper_trail.boolean_false")
    when Date, Time, DateTime
      l(value, format: :short)
    # Add other specific type handling here if needed (e.g., numbers)
    # when Numeric
    #   number_with_precision(value, precision: 2) # Example
    else
      value.to_s
    end
  end
end
