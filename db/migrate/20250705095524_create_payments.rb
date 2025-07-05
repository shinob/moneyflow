class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :invoice, null: false, foreign_key: true
      t.date :payment_date
      t.decimal :amount, precision: 10, scale: 2
      t.timestamps
    end
  end
end