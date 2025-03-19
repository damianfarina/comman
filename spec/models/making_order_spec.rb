require 'rails_helper'

RSpec.describe MakingOrder, type: :model do
  let(:formula) { create(:formula, :with_items) }
  let(:product1) { create(:manufactured_productable, formula: formula, weight: 10) }
  let(:product2) { create(:manufactured_productable, formula: formula, weight: 4) }
  let(:making_order_items) do
    [
      build(:making_order_item, product: product1, quantity: 2),
      build(:making_order_item, product: product2, quantity: 1),
    ]
  end
  let(:making_order) do
    build(
      :making_order,
      formula: nil,
      formula_id: formula.id,
      making_order_formula: nil,
      making_order_items: making_order_items,
      mixer_capacity: 20,
    )
  end

  before { making_order.valid? }

  it "sets formula" do
    expect(making_order.making_order_formula.formula_id).to eq(formula.id)
  end

  it "sets total weight" do
    expect(making_order.total_weight).to eq(24)
  end

  it "sets rounds count" do
    expect(making_order.rounds_count).to eq(2)
  end

  it "sets weight per round" do
    expect(making_order.weight_per_round).to eq(12)
  end

  it "sets formula dirty" do
    making_order.total_weight = 200
    making_order.valid?
    making_order.making_order_formula_items.each do |item|
      expect(item.consumed_stock_changed?).to eq(false)
    end
  end

  it "converts rich text to plain text" do
    making_order.comments = ActionText::RichText.new(body: "<p>This <i>is</i> a comment</p>")
    making_order.save
    expect(making_order.comments_plain_text).to eq("This is a comment")
  end
end
