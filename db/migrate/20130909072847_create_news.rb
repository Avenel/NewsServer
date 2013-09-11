class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.text :title
      t.text :content
      t.string :organisation
      t.date :date

      t.timestamps
    end
  end
end
