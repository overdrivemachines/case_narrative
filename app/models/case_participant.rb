# == Schema Information
#
# Table name: case_participants
#
#  id                  :uuid             not null, primary key
#  confidential        :boolean          default(FALSE), not null
#  date_of_birth       :date
#  date_of_death       :date
#  display_name        :string(180)      not null
#  email               :string(254)
#  first_name          :string(80)
#  identifiers         :jsonb            not null
#  last_name           :string(80)
#  metadata            :jsonb            not null
#  middle_name         :string(80)
#  name_suffix         :string(20)
#  organization_name   :string(180)
#  participant_type    :string(32)       not null
#  phone               :string(40)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  address_id          :uuid
#  attorney_profile_id :uuid
#  created_by_id       :uuid
#  user_id             :uuid
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id) ON DELETE => restrict
#  fk_rails_...  (attorney_profile_id => attorney_profiles.id) ON DELETE => nullify
#  fk_rails_...  (created_by_id => users.id) ON DELETE => nullify
#  fk_rails_...  (user_id => users.id) ON DELETE => nullify
#
class CaseParticipant < ApplicationRecord
  PARTICIPANT_TYPES = %w[
    individual company business state government police_department nonprofit estate trust other
  ].freeze
  EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP

  belongs_to :user, optional: true
  belongs_to :attorney_profile, optional: true
  belongs_to :address, optional: true
  belongs_to :created_by, class_name: "User", optional: true

  has_many :case_participations, dependent: :destroy
  has_many :cases, through: :case_participations
  has_many :asserted_case_issues,
           class_name: "CaseIssue",
           foreign_key: :asserted_by_participant_id,
           dependent: :nullify,
           inverse_of: :asserted_by_participant
  has_many :filed_case_documents,
           class_name: "CaseDocument",
           foreign_key: :filed_by_participant_id,
           dependent: :nullify,
           inverse_of: :filed_by_participant

  auto_strip_attributes :display_name,
                        :first_name,
                        :middle_name,
                        :last_name,
                        :name_suffix,
                        :organization_name,
                        :email,
                        :phone

  validates :participant_type, :display_name, presence: true
  validates :participant_type, inclusion: { in: PARTICIPANT_TYPES }
  validates :display_name, :organization_name, length: { maximum: 180 }, allow_blank: true
  validates :first_name, :middle_name, :last_name, length: { maximum: 80 }, allow_blank: true
  validates :name_suffix, length: { maximum: 20 }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: EMAIL_FORMAT }, allow_blank: true
  validates :phone, length: { maximum: 40 }, allow_blank: true
  validate :organization_name_is_present_for_organizations
  validate :date_of_death_is_not_before_date_of_birth

  private

  def organization_name_is_present_for_organizations
    return if participant_type.blank? || participant_type == "individual" || organization_name.present?

    errors.add(:organization_name, "is required for an organization")
  end

  def date_of_death_is_not_before_date_of_birth
    return if date_of_death.blank? || date_of_birth.blank? || date_of_death >= date_of_birth

    errors.add(:date_of_death, "cannot be before the date of birth")
  end
end
