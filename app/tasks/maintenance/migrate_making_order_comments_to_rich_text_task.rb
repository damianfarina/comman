# frozen_string_literal: true

module Maintenance
  class MigrateMakingOrderCommentsToRichTextTask < MaintenanceTasks::Task
    include ActionView::Helpers::TextHelper

    def collection
      MakingOrder.all
    end

    def process(making_order)
      return if making_order.comments.present?

      making_order.update_attribute(:comments, simple_format(making_order.comments_plain_text))
    end

    def count
      MakingOrder.count
    end
  end
end
