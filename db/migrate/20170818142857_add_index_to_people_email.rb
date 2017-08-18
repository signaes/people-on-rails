class AddIndexToPeopleEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :people, :email, unique: true
  end
end
