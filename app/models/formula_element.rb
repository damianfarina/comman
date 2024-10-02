class FormulaElement < ApplicationRecord
end

# == Schema Information
#
# Table name: formula_elements
#
#  id            :bigint           not null, primary key
#  current_stock :float            default(0.0)
#  infinite      :boolean
#  min_stock     :float            default(1.0)
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
