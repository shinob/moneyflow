class CreateEstimates < ActiveRecord::Migration[7.1]
  def change
    create_table :estimates do |t|
      t.references :client, null: false, foreign_key: true
      t.date :issue_date
      t.date :expiry_date
      t.decimal :amount, precision: 10, scale: 2
      t.string :status
      t.timestamps
    end
  end
end