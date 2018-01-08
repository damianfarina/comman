require 'spec_helper'

describe Reporting do
  def time_travel_to(time)
    Timecop.travel(time)
    yield if block_given?
  end

  def create_order_for(product, quantity)
    create :making_order,
      making_order_items: [
        build(:making_order_item, product: product, quantity: quantity)
      ]
  end

  before(:all) do
    formula = create :formula_with_items
    product = create :product, formula: formula, weight: 1.1

    time_travel_to(Time.local(2011, 1, 1)) { create_order_for product, 2 }
    time_travel_to(Time.local(2011, 2, 1)) { create_order_for product, 4 }
    time_travel_to(Time.local(2011, 3, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2011, 4, 1)) { create_order_for product, 2 }
    time_travel_to(Time.local(2011, 5, 1)) { create_order_for product, 4 }
    time_travel_to(Time.local(2011, 6, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2011, 7, 1)) { create_order_for product, 2 }
    time_travel_to(Time.local(2011, 8, 1)) { create_order_for product, 4 }
    time_travel_to(Time.local(2011, 9, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2011, 10, 1)) { create_order_for product, 2 }
    time_travel_to(Time.local(2011, 11, 1)) { create_order_for product, 4 }
    time_travel_to(Time.local(2011, 12, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2012, 1, 1)) { create_order_for product, 1 }
    time_travel_to(Time.local(2012, 2, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2012, 3, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2012, 4, 1)) { create_order_for product, 1 }
    time_travel_to(Time.local(2012, 5, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2012, 6, 1)) { create_order_for product, 1 }
    time_travel_to(Time.local(2012, 6, 5)) { create_order_for product, 2 }
    time_travel_to(Time.local(2012, 7, 1)) { create_order_for product, 1 }
    time_travel_to(Time.local(2012, 8, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2012, 9, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2012, 10, 1)) { create_order_for product, 1 }
    time_travel_to(Time.local(2012, 11, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2012, 12, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2013, 1, 1)) { create_order_for product, 2 }
    time_travel_to(Time.local(2013, 2, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2013, 3, 1)) { create_order_for product, 2 }
    time_travel_to(Time.local(2013, 4, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2013, 5, 1)) { create_order_for product, 3 }
    time_travel_to(Time.local(2013, 6, 2)) { create_order_for product, 4 }
  end

  it 'should return an array of production values per month/year' do
    expect(Reporting.production_monthly).to eq([
      {'month' => '1',  'year' => '2011', 'weight' => '2.20'},
      {'month' => '2',  'year' => '2011', 'weight' => '4.40'},
      {'month' => '3',  'year' => '2011', 'weight' => '3.30'},
      {'month' => '4',  'year' => '2011', 'weight' => '2.20'},
      {'month' => '5',  'year' => '2011', 'weight' => '4.40'},
      {'month' => '6',  'year' => '2011', 'weight' => '3.30'},
      {'month' => '7',  'year' => '2011', 'weight' => '2.20'},
      {'month' => '8',  'year' => '2011', 'weight' => '4.40'},
      {'month' => '9',  'year' => '2011', 'weight' => '3.30'},
      {'month' => '10', 'year' => '2011', 'weight' => '2.20'},
      {'month' => '11', 'year' => '2011', 'weight' => '4.40'},
      {'month' => '12', 'year' => '2011', 'weight' => '3.30'},
      {'month' => '1',  'year' => '2012', 'weight' => '1.10'},
      {'month' => '2',  'year' => '2012', 'weight' => '3.30'},
      {'month' => '3',  'year' => '2012', 'weight' => '3.30'},
      {'month' => '4',  'year' => '2012', 'weight' => '1.10'},
      {'month' => '5',  'year' => '2012', 'weight' => '3.30'},
      {'month' => '6',  'year' => '2012', 'weight' => '3.30'},
      {'month' => '7',  'year' => '2012', 'weight' => '1.10'},
      {'month' => '8',  'year' => '2012', 'weight' => '3.30'},
      {'month' => '9',  'year' => '2012', 'weight' => '3.30'},
      {'month' => '10', 'year' => '2012', 'weight' => '1.10'},
      {'month' => '11', 'year' => '2012', 'weight' => '3.30'},
      {'month' => '12', 'year' => '2012', 'weight' => '3.30'},
      {'month' => '1', 'year' => '2013', 'weight' => '2.20'},
      {'month' => '2', 'year' => '2013', 'weight' => '3.30'},
      {'month' => '3', 'year' => '2013', 'weight' => '2.20'},
      {'month' => '4', 'year' => '2013', 'weight' => '3.30'},
      {'month' => '5', 'year' => '2013', 'weight' => '3.30'},
      {'month' => '6', 'year' => '2013', 'weight' => '4.40'}
    ])
  end

  it 'should return an array of production values per year' do
    expect(Reporting.production_yearly).to include(
      {'year' => '2011', 'weight' => '39.60'},
      {'year' => '2012', 'weight' => '30.80'}
    )
  end

  context 'in June of current year' do
    let(:incomplete_year_data) { {'year' => '2013', 'weight' => '36.3'} }

    it 'should guess this year upcoming months using previous year months' do
      expect(Reporting.production_yearly).to include(incomplete_year_data)
    end
  end
end
