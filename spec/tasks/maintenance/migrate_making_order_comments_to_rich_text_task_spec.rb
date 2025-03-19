# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe MigrateMakingOrderCommentsToRichTextTask do
    describe "#process" do
      subject(:process) { described_class.process(element) }
      let(:element) { create(:making_order, :with_products, comments: nil, comments_plain_text: "This is a comment") }

      it "sets migrates the plain text to rich text" do
        process
        expect(element.reload.comments.to_plain_text).to eq("This is a comment")
      end

      it "skips the making order if the comments are already rich text" do
        element.update_attribute(:comments, ActionText::RichText.new(body: "This is a rich comment"))
        expect(element.reload.comments.to_plain_text).to eq("This is a rich comment")
        process
        expect(element.reload.comments.to_plain_text).to eq("This is a rich comment")
      end
    end
  end
end
