module ApplicationHelper
  def number_with_precision(number, options = {})
    super(number, { precision: 3 }.merge(options))
  end

  def navigation_link_to(name, path, icon, exact = false)
    default_classes = "group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6 text-light-blue hover:bg-blue-700 hover:text-white"
    active_classes = "bg-blue-700 text-white"
    classes = current_or_nested_page?(path, exact) ? "#{default_classes} #{active_classes}" : default_classes
    aria_current = current_page?(path) ? "page" : false

    content_tag(:a, href: path, class: classes, 'aria-current': aria_current) do
      concat heroicon(icon, options: { class: "h-6 w-6 shrink-0 text-current-color group-hover:text-white" })
      concat name
    end
  end

  def namespace_link_to(name, path)
    default_classes = "group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6 text-light-blue hover:bg-blue-700 hover:text-white"
    active_classes = "bg-blue-700 text-white"
    classes = current_or_nested_page?(path) ? "#{default_classes} #{active_classes}" : default_classes
    aria_current = current_page?(path) ? "page" : false

    content_tag(:a, href: path, class: classes, 'aria-current': aria_current) do
      content_tag(:span, class: "flex h-6 w-6 shrink-0 items-center justify-center rounded-lg border border-blue bg-blue-300 text-[0.625rem] font-medium text-white") do
        concat name.first
      end +
      content_tag(:span, class: "truncate") do
        concat name
      end
    end
  end

  def current_or_nested_page?(path, exact = false)
    exact ? current_page?(path) : current_page?(path) || request.path.start_with?(path)
  end

  def navigation_items
    case request.path
    when /^\/office/
      [
        { name: t("navigation.dashboard"), path: office_root_path, icon: "home", exact: true },
        { name: t("titles.client.index"), path: office_clients_path, icon: "user-group" },
        { name: t("titles.supplier.index"), path: office_suppliers_path, icon: "truck" },
        { name: t("titles.product.index"), path: office_products_path, icon: "cube" },
        { name: t("titles.user.index"), path: office_users_path, icon: "user" },
        { name: t("titles.setting.index"), path: office_settings_path, icon: "cog-8-tooth" },
      ]
    when /^\/sales/
      [
        { name: t("navigation.dashboard"), path: sales_root_path, icon: "home", exact: true },
        { name: t("sales.clients.index.title"), path: sales_clients_path, icon: "user-group" },
        { name: t("sales.sales_orders.index.title"), path: sales_sales_orders_path, icon: "shopping-bag" },
      ]
    when /^\/factory/
      [
        { name: t("navigation.dashboard"), path: factory_root_path, icon: "home", exact: true },
        { name: t("titles.making_order.index"), path: factory_making_orders_path, icon: "circle-stack" },
        { name: t("titles.product.index"), path: factory_products_path, icon: "cube" },
        { name: t("titles.formula.index"), path: factory_formulas_path, icon: "beaker" },
        { name: t("titles.formula_element.index"), path: factory_formula_elements_path, icon: "puzzle-piece" },
      ]
    else
      []
    end
  end

  def safe_url(url)
    uri = URI.parse(url)
    uri.scheme.in?(%w[http https]) ? url : "#"
  rescue URI::InvalidURIError
    "#"
  end

  def status_container_for(status, opts = {})
    color_classes = {
      "quote"       => "text-gray-300 outline-gray-100",
      "confirmed"   => "text-light-blue-900 outline-light-blue",
      "in_progress" => "text-yellow outline-yellow",
      "ready"       => "text-blue outline-blue",
      "delivered"   => "text-light-green-900 outline-light-green",
      "fulfilled"   => "text-green outline-green",
      "cancelled"   => "text-light-red-900 outline-light-red",
    }
    content_tag(:span, class: "inline-block px-1.5 py-1 rounded-md shadow-sm outline-1 -outline-offset-1 bg-white-100 #{color_classes[status.to_s]} #{opts[:class]}") do
      block_given? ? yield : status.to_s.humanize
    end
  end
end
