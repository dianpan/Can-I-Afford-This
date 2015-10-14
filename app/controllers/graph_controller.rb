class GraphController < ApplicationController
  before_action :find_user

  def index
  end

  def net_savings_data
    @income = @user.income
    @expenses = current_user.expensesheet_snapshot
    @user_expenses = @user.expenses.pluck(:amount).reduce(:+)
    respond_to do |format|
      format.json{
        render json: { income: @income, expenses: @user_expenses, percentages: @expenses }
      }
    end
  end

  def savings_vs_purchase_data
    @savings = @user.total_savings
    # @user_purchases = @user.purchases.pluck(:cost).reduce(:+)
    @purchases = Purchase.snapshot(@user.purchases)
    respond_to do |format|
      format.json{
        render json: { savings: @savings, purchases: @purchases }
      }
    end
  end

  def expense_percentages_data
    @expenses = Expense.total_percentages(@user.expenses, @user.income)
    respond_to do |format|
      format.json{
        render json: { expenses: @expenses }
      }
    end
  end

  private
  def find_user
    @user = User.find(session[:user_id])
  end

end