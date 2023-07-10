class ItemsController < ApplicationController

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

  def user_index
    @items = Item.all
    @items = @items.where(user_id: current_user)
  end

  def new
    @item = Item.new
  end

  def destroy
    @item = Item.find(params[:id])
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

end
