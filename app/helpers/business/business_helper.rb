module Business::BusinessHelper
  def is_clients_active?
    params[:controller].match('business/clients.*')
  end
  def is_delivery_notes_active?
    params[:controller].match('business/delivery_notes.*')
  end
end
