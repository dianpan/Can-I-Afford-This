class ExpenseType < ActiveRecord::Base
  validates_presence_of :name

  has_many :expenses
end