module Business::DeliveryNotesHelper
  def delivery_note_state(delivery_note)
    case delivery_note.state
    when DeliveryNote::STATE_OPEN
      content_tag :span, :class => 'label label-info' do
        "Abierto"
      end
    when DeliveryNote::STATE_DELIVERED
      content_tag :span, :class => 'label label-success' do
        "Listo para facturar"
      end
    when DeliveryNote::STATE_CLOSED
      content_tag :span, :class => 'label label-inverse' do
        "Cerrado"
      end
    end
  end

  def delivery_states_for_select
    [
      ["Abierto", 0],
      ["Listo para facturar", 1],
      ["Cerrado", 2]
    ]
  end

  def clients_as_json
    Client.pluck(:name).to_json
  end

  def links_by_state(delivery_note)
    case delivery_note.state
    when DeliveryNote::STATE_OPEN
      link_to "Liberar", liberate_business_delivery_note_path(delivery_note), :method => :post, :class => 'btn btn-success btn-large'
    when DeliveryNote::STATE_DELIVERED
      link_to "Cerrar", close_business_delivery_note_path(delivery_note), :method => :post, :class => 'btn btn-warning btn-large'
    end
  end
end
