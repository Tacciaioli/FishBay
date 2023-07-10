class AddPhoneNumberToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone_number, :integer
  end
end
