class CreateMateStocks < ActiveRecord::Migration
  def change
    create_table :mate_stocks do |t|
      t.integer :mateOriginal
      t.integer :mateCola
      t.integer :mateGranada
      t.integer :coffee

      t.timestamps
    end
  end
end
