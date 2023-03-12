class Employee < ActiveRecord::Base
  belongs_to :company
  validates :email, presence: true, uniqueness: { message: 'Employee exists with the same email' }

end
