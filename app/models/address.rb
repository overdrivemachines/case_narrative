# == Schema Information
#
# Table name: addresses
#
#  id           :uuid             not null, primary key
#  city         :string(80)
#  country_code :string(2)        default("US"), not null
#  line_1       :string(120)
#  line_2       :string(120)
#  postal_code  :string(20)
#  state        :string(80)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Address < ApplicationRecord
  COUNTRY_CODE_FORMAT = /\A[A-Z]{2}\z/

  has_many :users, dependent: :restrict_with_error
  has_many :courthouses, dependent: :restrict_with_error
  has_many :attorney_profiles, dependent: :restrict_with_error
  has_many :case_participants, dependent: :restrict_with_error

  before_validation :normalize_region_codes

  auto_strip_attributes :line_1, :line_2, :city, :state, :postal_code, :country_code

  validates :line_1, :city, :country_code, presence: true
  validates :line_1, :line_2, length: { maximum: 120 }, allow_blank: true
  validates :city, :state, length: { maximum: 50 }, allow_blank: true
  validates :postal_code, length: { maximum: 10 }, allow_blank: true
  validates :country_code, format: { with: COUNTRY_CODE_FORMAT }

  validate :state_is_supported_for_united_states_address

  private

  def normalize_region_codes
    self.country_code = country_code&.upcase
    self.state = state&.upcase if country_code == "US"
  end

  def state_is_supported_for_united_states_address
    return unless country_code == "US" && state.present? && UsStates::CODES.exclude?(state)

    errors.add(:state, "is not a valid U.S. state or territory")
  end
end
