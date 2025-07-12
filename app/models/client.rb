class Client < ActiveRecord::Base
  has_many :invoices, -> { order(issue_date: :desc) }
  has_many :estimates, -> { order(issue_date: :desc) }
end
