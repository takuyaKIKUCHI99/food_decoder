class CreateRestrictions < ActiveRecord::Migration[5.2]
  def change
    create_table :restrictions do |t|
      t.string :name
      t.string :photo
      t.text :description

      t.timestamps
    end
  end
end
