class AddAttachmentToInvoicesAndEstimates < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :attachment, :string
    add_column :estimates, :attachment, :string
  end
end