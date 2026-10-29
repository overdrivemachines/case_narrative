# == Schema Information
#
# Table name: case_documents
#
#  id                      :uuid             not null, primary key
#  authored_on             :date
#  confidential            :boolean          default(FALSE), not null
#  description             :text
#  document_number         :string(100)
#  document_type           :string(40)       not null
#  filed_at                :datetime
#  metadata                :jsonb            not null
#  received_at             :datetime
#  served_at               :datetime
#  status                  :string(32)       default("draft"), not null
#  title                   :string(180)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  case_id                 :uuid             not null
#  created_by_id           :uuid
#  filed_by_participant_id :uuid
#
# Foreign Keys
#
#  fk_rails_...  (case_id => cases.id) ON DELETE => cascade
#  fk_rails_...  (created_by_id => users.id) ON DELETE => nullify
#  fk_rails_...  (filed_by_participant_id => case_participants.id) ON DELETE => nullify
#
class CaseDocument < ApplicationRecord
  DOCUMENT_TYPES = %w[
    pleading motion order correspondence discovery contract affidavit transcript notice medical_record
    financial_record police_report exhibit other
  ].freeze
  STATUSES = %w[draft final filed served received superseded archived].freeze

  belongs_to :case
  belongs_to :created_by, class_name: "User", optional: true
  belongs_to :filed_by_participant, class_name: "CaseParticipant", optional: true

  auto_strip_attributes :document_type, :title, :document_number, :description, :status

  validates :document_type, :title, :status, presence: true
  validates :document_type, inclusion: { in: DOCUMENT_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :title, length: { maximum: 180 }
  validates :document_number, length: { maximum: 100 }, allow_blank: true
end
