class Purchase < ActiveRecord::Base
  validates_presence_of :cost
  validates_presence_of :title
  validates_numericality_of :cost, :greater_than => 0

  belongs_to :user
  has_one :purchase_type

  before_save :add_purchase_type_id

  def self.total_purchase_amount
    pluck(:cost).reduce(:+) || 0
  end

  def add_purchase_type_id
    self.purchase_type_id = \
      case cost.to_i
      when [0 .. 1000] then 1
      when [1000 .. 3000] then 2
      else 3
      end
  end

  def add_payoff_time
    payoff_time = \
      case self.purchase_type_id
      when 1 then 6
      when 2 then 12
      else 60
      end
  end

  def can_I_afford_this
    if !self.user.income.nil? && !self.user.expenses.empty?
      user_income = self.user.income
      user_expenses = self.user.expenses.total_expense_amount
    end
    income_to_expense_diff = user_income - user_expenses
    purchase_price = self.cost
    max_payoff_time = self.add_payoff_time
    months_to_payoff = (purchase_price / income_to_expense_diff.to_f).ceil
    if months_to_payoff <= max_payoff_time
      "Yes you can afford it!  By saving smart and not spending more than you earn, it will take you #{months_to_payoff} months to buy your Now start saving!"
    else
      "Sorry! No, you cannot afford it. Our conscenous would not be clear if we put you down this path.  It will take you #{months_to_payoff} months to save up for this purchase.  Consider lowering your existing expenses before attempting to make this purchase. Don't worry, we'll show you how."
    end
  end

end