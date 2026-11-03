# == Schema Information
#
# Table name: cases
#
#  id          :uuid             not null, primary key
#  case_number :string(100)      not null
#  case_type   :string(32)       not null
#  county      :string(120)      not null
#  description :text             not null
#  filed_on    :date             not null
#  status      :string(32)       not null
#  title       :string(180)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Case < ApplicationRecord
  auto_strip_attributes :title, :case_number, :case_type, :county, :status, :description

  validates :title, :case_number, :case_type, :county, :filed_on, :status, :description, presence: true
  validates :title, length: { maximum: 180 }
  validates :case_number,
            length: { maximum: 100 },
            uniqueness: { case_sensitive: false }
  validates :case_type, length: { maximum: 32 }
  validates :county, length: { maximum: 120 }
  validates :status, length: { maximum: 32 }
end
