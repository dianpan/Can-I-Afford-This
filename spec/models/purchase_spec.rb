require 'rails_helper'

describe Purchase do
  it 'is valid with a title, cost and purchase type id' do
    purchase = Purchase.new(
      title: "beats headphones",
      cost: 250,
      purchase_type_id: 1)
    expect(purchase).to be_valid
  end
  it 'is invalid without a title' do
    purchase = Purchase.new(title: nil)
    purchase.valid?
    expect(purchase.errors[:title]).to include("can't be blank")
  end
  it 'is invalid without a cost' do
    purchase = Purchase.new(cost: nil)
    purchase.valid?
    expect(purchase.errors[:cost]).to include("can't be blank")
  end
  it 'is invalid without a purchase type id' do
    purchase = Purchase.new(purchase_type_id: nil)
    expect(purchase.valid?).to eq(false)
  end
end