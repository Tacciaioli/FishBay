class AddYearToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :year, :integer
  end
end
