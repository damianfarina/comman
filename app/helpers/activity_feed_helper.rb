module ActivityFeedHelper
  def activity_change_value(auditable, attribute_name, value)
    return nil if value.blank? && value != false

    model_class = auditable.class

    # Enum handling
    if model_class.respond_to?(:defined_enums) && model_class.defined_enums.key?(attribute_name.to_s)
      i18n_key = model_class.model_name.i18n_key
      return I18n.t(
        "activerecord.attributes.#{i18n_key}.#{attribute_name}_values.#{value}",
        default: value.to_s,
      )
    end

    attr_type = model_class.type_for_attribute(attribute_name).type

    # Handle boolean values
    case value
    when true
      return I18n.t("auditable.boolean_true")
    when false
      return I18n.t("auditable.boolean_false")
    end

    # Handle prices
    if attribute_name.to_s.match?(/price$/)
      # Convert to float if not already, then format as currency
      return number_to_currency(value)
    end

    # Handle date/time types
    case attr_type
    when :date
      return l(value.to_date, format: :short) rescue value.to_s
    when :time
      return l(value.to_time, format: :short) rescue value.to_s
    when :datetime
      return l(value.to_datetime, format: :short) rescue value.to_s
    end

    value.to_s
  end

  def activity_event(event)
    event_string = event.to_s
    I18n.t("auditable.events.#{event_string}", default: event_string.humanize)
  end

  def link_to_auditable(auditable, options = {})
    path = polymorphic_path([ Current.department, auditable ]) rescue nil
    path ||= polymorphic_path(auditable) rescue nil

    if path
      link_to(
        auditable.audit_name,
        path,
        **options,
      )
    else
      content_tag(:span, auditable.audit_name)
    end
  end

  def auditable_field_name(auditable, field)
    field_name = field.split(".").first
    I18n.t("activerecord.attributes.#{auditable.class.name.underscore}.#{field_name}")
  end

  def auditable_type_name(auditable)
    I18n.t(
      auditable.class.name.underscore,
      scope: [ :activerecord, :models ],
      count: 1,
      default: auditable.class.name.humanize,
    )
  end

  def activity_user_name(user)
    user&.name.presence || t("auditable.unknown_user")
  end
end
