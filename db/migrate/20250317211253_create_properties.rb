class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.string :title
      t.text :description
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.decimal :price_per_night
      t.decimal :latitude
      t.decimal :longitude
      t.string :property_type
      t.integer :max_guests
      t.integer :bedrooms
      t.integer :bathrooms
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
