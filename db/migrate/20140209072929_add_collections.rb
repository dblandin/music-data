class AddCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string  :type
      t.integer :page

      t.timestamps
    end
  end
end
