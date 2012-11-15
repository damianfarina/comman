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
    when DeliveryNote::STATE_CLOSE
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
end
