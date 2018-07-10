class CreateCategoriesTable < ActiveRecord::Migration[5.2]
  def up
    create_table :categories do |t|
      t.string :category_name
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :categories
  end
end
