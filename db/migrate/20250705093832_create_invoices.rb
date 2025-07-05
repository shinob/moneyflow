class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.references :client, null: false, foreign_key: true
      t.date :issue_date
      t.date :due_date
      t.decimal :amount, precision: 10, scale: 2
      t.string :status
      t.timestamps
    end
  end
end