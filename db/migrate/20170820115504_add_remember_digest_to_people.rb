class AddRememberDigestToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :remember_digest, :string
  end
end
