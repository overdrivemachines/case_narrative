# == Schema Information
#
# Table name: cases
#
#  id             :uuid             not null, primary key
#  case_number    :string(100)      not null
#  case_type      :string(32)       not null
#  charges        :jsonb            not null
#  closed_on      :date
#  confidential   :boolean          default(FALSE), not null
#  court_division :string(100)
#  description    :text
#  filed_on       :date
#  judge_name     :string(120)
#  lock_version   :integer          default(0), not null
#  metadata       :jsonb            not null
#  next_event_at  :datetime
#  start_date     :date             not null
#  status         :string(32)       default("active"), not null
#  summary        :text
#  title          :string(180)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  courthouse_id  :uuid
#  created_by_id  :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (courthouse_id => courthouses.id) ON DELETE => nullify
#  fk_rails_...  (created_by_id => users.id) ON DELETE => restrict
#
class Case < ApplicationRecord
  CASE_TYPES = %w[criminal civil family probate mental_health other].freeze
  STATUSES = %w[active pending inactive stayed settled dismissed closed appealed reopened archived].freeze
  TITLE_MAXIMUM_LENGTH = 180
  CASE_NUMBER_MAXIMUM_LENGTH = 100
  CHARGE_CODE_MAXIMUM_LENGTH = 120
  CHARGE_DESCRIPTION_MAXIMUM_LENGTH = 500

  belongs_to :courthouse, optional: true
  belongs_to :created_by, class_name: "User"

  has_many :case_participations, dependent: :destroy
  has_many :case_participants, through: :case_participations
  has_many :case_issues, dependent: :destroy
  has_many :case_events, dependent: :destroy
  has_many :case_documents, dependent: :destroy

  auto_strip_attributes :title, :case_number, :court_division, :judge_name, :description, :summary

  validates :title, :case_number, :case_type, :status, :start_date, presence: true
  validates :title, length: { maximum: TITLE_MAXIMUM_LENGTH }
  validates :case_number,
            length: { maximum: CASE_NUMBER_MAXIMUM_LENGTH },
            uniqueness: { case_sensitive: false, scope: :courthouse_id }
  validates :case_type, inclusion: { in: CASE_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :court_division, length: { maximum: 100 }, allow_blank: true
  validates :judge_name, length: { maximum: 120 }, allow_blank: true

  validate :closed_on_is_not_before_start_date
  validate :charges_are_well_formed

  private

  def closed_on_is_not_before_start_date
    return if closed_on.blank? || start_date.blank? || closed_on >= start_date

    errors.add(:closed_on, "cannot be before the case start date")
  end

  def charges_are_well_formed
    unless charges.is_a?(Array)
      errors.add(:charges, "must be an array")
      return
    end

    charges.each_with_index do |charge, index|
      unless charge.is_a?(Hash)
        errors.add(:charges, "entry #{index + 1} must contain a charge code and description")
        next
      end

      code = charge["code"] || charge[:code]
      description = charge["description"] || charge[:description]

      errors.add(:charges, "entry #{index + 1} must include a charge code") if code.blank?
      errors.add(:charges, "entry #{index + 1} must include a charge description") if description.blank?
      errors.add(:charges, "entry #{index + 1} charge code is too long") if code.to_s.length > CHARGE_CODE_MAXIMUM_LENGTH
      if description.to_s.length > CHARGE_DESCRIPTION_MAXIMUM_LENGTH
        errors.add(:charges, "entry #{index + 1} charge description is too long")
      end
    end
  end
end
