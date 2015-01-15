class CreateShortens < ActiveRecord::Migration
  def change
    create_table :shortens do |t|
      t.string :url
      t.string :shortcode
      t.datetime :startdate
      t.datetime :lastseendate
      t.integer :redirectcount

      t.timestamps null: false
    end
  end
end
