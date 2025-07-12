class AddSubmissionDateToDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :submission_date, :date
    add_column :estimates, :submission_date, :date
  end
end