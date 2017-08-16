class Ticket < ApplicationRecord
  validates :name, presence: true
  belongs_to :event
  has_many :registrations
end
