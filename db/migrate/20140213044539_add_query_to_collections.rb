class AddQueryToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :query, :string
  end
end
