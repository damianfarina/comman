class Formula < ApplicationRecord
end

# == Schema Information
#
# Table name: formulas
#
#  id         :bigint           not null, primary key
#  abrasive   :string
#  alloy      :string
#  grain      :string
#  hardness   :string
#  name       :string
#  porosity   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
