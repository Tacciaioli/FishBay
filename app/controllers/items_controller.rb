class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.all
    if params[:query].present?
      sql_subquery = <<~SQL
        items.name @@ :query
        OR items.description @@ :query
        OR items.brand @@ :query
      SQL
      @items = @items.where(sql_subquery, query: params[:query])
    end
  end

  def show
  end

  def user_index
    @items = Item.all
    @items = @items.where(user_id: current_user)
  end

  def user_page
    @items = Item.all
    @user = User.find(params[:format])
    @items = @items.where(user_id: @user)

  end

  def new
    @item = Item.new
  end

  def destroy
    @item.destroy
    redirect_to my_items_path, status: :see_other
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user
    if @item.save
      redirect_to items_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :brand, :weight, :size, :year, :description, :price, :photo )
  end

  def set_item
    @item = Item.find(params[:id])
  end

end
