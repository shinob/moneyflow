class AddDirectionToEstimates < ActiveRecord::Migration[7.1]
  def change
    add_column :estimates, :direction, :string
  end
end