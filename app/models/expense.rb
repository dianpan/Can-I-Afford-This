class Expense < ActiveRecord::Base
  validates_presence_of :amount
  validates_numericality_of :amount, :greater_than => 0

  belongs_to :user
  has_one :expense_type

  def self.total_expense_amount
    pluck(:amount).reduce(:+) || 0
  end

  def self.expense_sheet(data)
    data.map do |type, v|
      self.new(expense_type_id: type, amount: v)
    end
  end

  def self.snapshot(data, income)
    types = data.map { |d| ExpenseType.find(d.expense_type_id).name}
    values = data.map { |d| d.amount}
    percentages = values.map { |v| ((v.to_f/income.to_f)* 100).floor }
    [types, values].transpose.to_h
  end
end