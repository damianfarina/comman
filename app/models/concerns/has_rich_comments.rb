module HasRichComments
  extend ActiveSupport::Concern

  included do
    has_rich_text :comments
    before_save :set_comments_plain_text, if: -> { self.comments.present? }

    private

      def set_comments_plain_text
        self.comments_plain_text = self.comments.to_plain_text
      end
  end
end
