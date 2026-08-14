# == Schema Information
#
# Table name: attorney_profiles
#
#  id              :uuid             not null, primary key
#  bar_number      :string(80)
#  court_appointed :boolean          default(FALSE), not null
#  email           :string(254)
#  firm_name       :string(180)
#  job_title       :string(100)
#  licensing_state :string(2)
#  metadata        :jsonb            not null
#  phone           :string(40)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  address_id      :uuid
#  user_id         :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id) ON DELETE => restrict
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class AttorneyProfile < ApplicationRecord
  EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP

  belongs_to :user
  belongs_to :address, optional: true

  has_many :case_participants, dependent: :nullify

  auto_strip_attributes :bar_number, :licensing_state, :firm_name, :job_title, :email, :phone

  validates :bar_number, length: { maximum: 6 }, allow_blank: true
  validates :licensing_state,
            length: { is: 2 },
            inclusion: { in: UsStates::CODES },
            allow_blank: true
  validates :firm_name, length: { maximum: 180 }, allow_blank: true
  validates :job_title, length: { maximum: 100 }, allow_blank: true
  validates :email, length: { maximum: 80 }, format: { with: EMAIL_FORMAT }, allow_blank: true
  validates :phone, length: { maximum: 10 }, allow_blank: true
  validates :user_id, uniqueness: true
  validates :bar_number, uniqueness: { scope: :licensing_state }, allow_blank: true

  validate :license_fields_are_complete

  private

  def license_fields_are_complete
    return if bar_number.blank? && licensing_state.blank?

    errors.add(:bar_number, "is required when a licensing state is provided") if bar_number.blank?
    errors.add(:licensing_state, "is required when a bar number is provided") if licensing_state.blank?
  end
end
