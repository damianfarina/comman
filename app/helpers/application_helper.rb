module ApplicationHelper

  def is_factory_active?
    params[:controller].match('factory_.*')
  end

  def is_business_active?
    params[:controller].match('business_.*')
  end

  def action_safe_name
    params[:action]
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

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.simple_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => 'btn')
  end

  def link_to_remove_field(name, f, options = {})
    f.input(:_destroy, :as => :hidden) + link_to_function(name, "remove_field(this)", options)
  end
end
