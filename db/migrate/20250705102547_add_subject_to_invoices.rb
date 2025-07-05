class AddSubjectToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :subject, :string
  end
end