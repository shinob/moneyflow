class AddSubjectToEstimates < ActiveRecord::Migration[7.1]
  def change
    add_column :estimates, :subject, :string
  end
end