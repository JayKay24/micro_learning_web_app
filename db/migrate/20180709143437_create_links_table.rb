class CreateLinksTable < ActiveRecord::Migration[5.2]
  def up
    create_table :links do |t|
      t.string :link_name

      t.references :category, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :links
  end
end
