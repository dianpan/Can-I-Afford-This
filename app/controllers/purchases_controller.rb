class PurchasesController < ApplicationController
  before_action :find_user

  def index
    @purchase = Purchase.new
    @purchases = @user.purchases.all
  end

  def show
    @purchase = Purchase.find params[:id]
    @purchase_price = @user.purchases.find(params[:id]).cost
    # byebug
      # if @payoff_time <= 12
      #   alert("YES! It will take you #{@payoff_time} months to save.")
      # else
      #   alert("No, you should hold off on this purchase")
      # end
  end

  def new
    @purchase = Purchase.new
  end

  def create
    purchase = @user.purchases.create(purchases_params)
    flash[:error] = "Your purchase must be greater than $0." if !purchase.save
    redirect_to user_path(session[:user_id])
  end

  def edit
    @purchase = Purchase.find(params[:id])
  end

  def update
    @purchase = Purchase.find(params[:id])
    if @purchase.update_attributes purchases_params
      redirect_to user_path(session[:user_id])
    else
      flash[:error] = "Your purchase must have a name and be greater than $0."
      redirect_to user_path(session[:user_id])
    end
  end

   def destroy
    purchase = Purchase.find(params[:id])
    purchase.destroy
    redirect_to user_path(session[:user_id])
  end


  private

  def find_user
    @user = User.find(session[:user_id])
  end

  def purchases_params
    params.require(:purchase).permit(:purchase_type_id, :cost, :title)
  end
end
