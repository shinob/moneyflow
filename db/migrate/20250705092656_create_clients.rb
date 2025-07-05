class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :address
      t.string :contact_person
      t.string :phone_number
      t.timestamps
    end
  end
end