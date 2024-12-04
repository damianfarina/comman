require "rails_helper"

describe Factory::FormulaElementsHelper, type: :helper do
  describe "#stock_level_color" do
    it "returns red for 0% stock level" do
      expect(helper.stock_level_color(0)).to eq("rgb(238,96,84)")
    end

    it "returns yellow for 50% stock level" do
      expect(helper.stock_level_color(50)).to eq("rgb(255,194,51)")
    end

    it "returns green for 100% stock level" do
      expect(helper.stock_level_color(100)).to eq("rgb(96,211,148)")
    end

    it "returns an interpolated orange color for 25% stock level" do
      expect(helper.stock_level_color(25)).to eq("rgb(247,145,68)") # Orange between red and yellow
    end

    it "clamps percentages below 0 to red" do
      expect(helper.stock_level_color(-10)).to eq("rgb(238,96,84)")
    end

    it "clamps percentages above 100 to green" do
      expect(helper.stock_level_color(150)).to eq("rgb(96,211,148)")
    end
  end

  describe "#interpolate_color" do
    it "returns the start color when ratio is 0" do
      expect(helper.interpolate_color("#FF0000", "#FFFF00", 0)).to eq("rgb(255,0,0)")
    end

    it "returns the end color when ratio is 1" do
      expect(helper.interpolate_color("#FF0000", "#FFFF00", 1)).to eq("rgb(255,255,0)")
    end

    it "returns a blended color for a ratio of 0.5" do
      expect(helper.interpolate_color("#FF0000", "#FFFF00", 0.5)).to eq("rgb(255,128,0)") # Orange
    end

    it "handles invalid ratios gracefully (negative ratio)" do
      expect(helper.interpolate_color("#FF0000", "#FFFF00", -1)).to eq("rgb(255,0,0)") # Start color
    end

    it "handles invalid ratios gracefully (ratio > 1)" do
      expect(helper.interpolate_color("#FF0000", "#FFFF00", 2)).to eq("rgb(255,255,0)") # End color
    end
  end
end
