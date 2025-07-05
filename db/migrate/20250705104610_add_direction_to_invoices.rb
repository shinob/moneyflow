class AddDirectionToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :direction, :string
  end
end