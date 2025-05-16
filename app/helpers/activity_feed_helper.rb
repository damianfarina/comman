module ActivityFeedHelper
  def activity_change_value(auditable, attribute_name, value)
    return nil if value.blank? && value != false

    model_class = auditable.class

    if model_class.respond_to?(:defined_enums) && model_class.defined_enums.key?(attribute_name.to_s)
      i18n_key = model_class.model_name.i18n_key
      return I18n.t(
        "activerecord.attributes.#{i18n_key}.#{attribute_name}_values.#{value}",
        default: value.to_s,
      )
    end

    case value
    when TrueClass
      t("auditable.boolean_true")
    when FalseClass
      t("auditable.boolean_false")
    when Date, Time, DateTime
      l(value, format: :short)
    else
      value.to_s
    end
  end

  def activity_event(event)
    I18n.t("auditable.events.#{event}", default: event.humanize)
  end

  def link_to_auditable(auditable, options = {})
    if path = polymorphic_path([ Current.department, auditable ]) rescue nil
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
    user&.name || t("auditable.unknown_user")
  end
end
