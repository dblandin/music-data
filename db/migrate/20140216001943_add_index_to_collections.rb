class AddIndexToCollections < ActiveRecord::Migration
  def up
    add_index :collections, [:query, :page]
  end

  def down
    remove_index :collections, [:query, :page]
  end
end
