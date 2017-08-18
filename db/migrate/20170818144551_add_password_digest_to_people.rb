class AddPasswordDigestToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :password_digest, :string
  end
end
