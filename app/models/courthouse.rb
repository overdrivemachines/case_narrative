# == Schema Information
#
# Table name: courthouses
#
#  id            :uuid             not null, primary key
#  homepage      :string(200)
#  jurisdiction  :string(80)       not null
#  name          :string(80)       not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  address_id    :uuid             not null
#  created_by_id :uuid
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id) ON DELETE => restrict
#  fk_rails_...  (created_by_id => users.id)
#
class Courthouse < ApplicationRecord
  NAME_LENGTH_RANGE = 2..80
  JURISDICTION_LENGTH_RANGE = 2..80
  HOMEPAGE_MAXIMUM_LENGTH = 200

  belongs_to :address
  belongs_to :created_by, class_name: "User", optional: true

  has_many :cases, dependent: :nullify

  auto_strip_attributes :name, :jurisdiction, :homepage

  validates :name, :address, :jurisdiction, presence: true
  validates :name, length: { in: NAME_LENGTH_RANGE }, uniqueness: { case_sensitive: false }
  validates :jurisdiction, length: { in: JURISDICTION_LENGTH_RANGE }
  validates :homepage, length: { maximum: HOMEPAGE_MAXIMUM_LENGTH }, allow_blank: true
  validates :homepage, url: { allow_blank: true }
end
