# == Schema Information
#
# Table name: courthouses
#
#  id            :uuid             not null, primary key
#  address       :string(50)       not null
#  city          :string(30)       not null
#  homepage      :string(200)
#  jurisdiction  :string(80)       not null
#  name          :string(80)       not null
#  state         :string(2)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :uuid
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
class Courthouse < ApplicationRecord
  NAME_LENGTH_RANGE = 2..80
  ADDRESS_LENGTH_RANGE = 5..50
  CITY_LENGTH_RANGE = 2..30
  STATE_LENGTH = 2
  JURISDICTION_LENGTH_RANGE = 2..80
  HOMEPAGE_MAXIMUM_LENGTH = 200

  belongs_to :created_by, class_name: "User", optional: true

  auto_strip_attributes :name, :address, :city, :state, :jurisdiction, :homepage

  validates :name, :address, :city, :state, :jurisdiction, presence: true
  validates :name, length: { in: NAME_LENGTH_RANGE }, uniqueness: { case_sensitive: false }
  validates :address, length: { in: ADDRESS_LENGTH_RANGE }
  validates :city, length: { in: CITY_LENGTH_RANGE }
  validates :state, length: { is: STATE_LENGTH }
  validates :jurisdiction, length: { in: JURISDICTION_LENGTH_RANGE }
  validates :homepage, length: { maximum: HOMEPAGE_MAXIMUM_LENGTH }, allow_blank: true
  validates :homepage, url: { allow_blank: true }
end
