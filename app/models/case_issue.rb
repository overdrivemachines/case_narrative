# == Schema Information
#
# Table name: case_issues
#
#  id                         :uuid             not null, primary key
#  description                :text
#  disposed_on                :date
#  disposition                :string(100)
#  issue_type                 :string(32)       not null
#  metadata                   :jsonb            not null
#  position                   :integer          default(1), not null
#  status                     :string(32)       default("open"), not null
#  statute_code               :string(120)
#  title                      :string(180)      not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  asserted_by_participant_id :uuid
#  case_id                    :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (asserted_by_participant_id => case_participants.id) ON DELETE => nullify
#  fk_rails_...  (case_id => cases.id) ON DELETE => cascade
#
class CaseIssue < ApplicationRecord
  ISSUE_TYPES = %w[
    claim allegation petition defense counterclaim custody_issue probate_issue mental_health_issue other
  ].freeze
  STATUSES = %w[open pending proven not_proven dismissed withdrawn resolved appealed].freeze

  belongs_to :case
  belongs_to :asserted_by_participant, class_name: "CaseParticipant", optional: true

  auto_strip_attributes :issue_type, :title, :description, :statute_code, :status, :disposition

  validates :issue_type, :title, :status, presence: true
  validates :issue_type, inclusion: { in: ISSUE_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :position, numericality: { only_integer: true, greater_than: 0 }
  validates :title, length: { maximum: 180 }
  validates :statute_code, length: { maximum: 120 }, allow_blank: true
  validates :disposition, length: { maximum: 100 }, allow_blank: true
end
