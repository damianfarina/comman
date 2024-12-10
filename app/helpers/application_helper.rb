module ApplicationHelper
  def sidebar_link(name, path, icon)
    default_classes = "group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6 text-lightBlue hover:bg-blue-700 hover:text-white"
    active_classes = "bg-blue-700 text-white"
    classes = current_or_nested_page?(path) ? "#{default_classes} #{active_classes}" : default_classes
    aria_current = current_page?(path) ? "page" : false

    content_tag(:li) do
      content_tag(:a, href: path, class: classes, 'aria-current': aria_current) do
        concat heroicon(icon, options: { class: "h-6 w-6 shrink-0 text-lightBlue group-hover:text-white" })
        concat name
      end
    end
  end

  def current_or_nested_page?(path)
    current_page?(path) || request.path.start_with?(path)
  end

  def navigation_items
    [
      { name: t("navigation.dashboard"), path: factory_dashboard_index_path, icon: "home" },
      { name: t("titles.making_order.index"), path: factory_making_orders_path, icon: "circle-stack" },
      { name: t("titles.formula.index"), path: factory_formulas_path, icon: "beaker" },
      { name: t("titles.formula_element.index"), path: factory_formula_elements_path, icon: "puzzle-piece" },
    ]
  end
end
