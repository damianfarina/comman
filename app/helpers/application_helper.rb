module ApplicationHelper

  def is_factory_active?
    params[:controller].match('factory_.*')
  end

  def is_business_active?
    params[:controller].match('business_.*')
  end

  def action_safe_name
    "action_#{params[:action]}"
  end

  def controller_safe_name
    params[:controller].gsub!("/", "_")
  end

  def sidebar(options)
    options[:label] ||= "Missing label"
    options[:path] ||= "#"
    options[:active] ||= false
    link += %Q(<li class="#{ options[:active] ? "active" : nil}">#{link_to(options[:label], options[:path])}</li>)
    content_for :sidebar do
      link.html_safe
    end
  end

end
