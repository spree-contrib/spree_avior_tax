class AddCountyToSpreeAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_addresses, :county, :string
  end
end
