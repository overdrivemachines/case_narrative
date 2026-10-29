# == Schema Information
#
# Table name: case_participations
#
#  id                  :uuid             not null, primary key
#  role                :string(40)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  case_id             :uuid             not null
#  case_participant_id :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (case_id => cases.id) ON DELETE => cascade
#  fk_rails_...  (case_participant_id => case_participants.id) ON DELETE => cascade
#
class CaseParticipation < ApplicationRecord
  ROLES = %w[
    plaintiff defendant petitioner respondent appellant appellee claimant attorney witness
    complaining_witness victim prosecutor judge law_enforcement_officer expert_witness
    guardian_ad_litem guardian subject decedent beneficiary executor administrator
    personal_representative trustee interested_party other
  ].freeze

  belongs_to :case
  belongs_to :case_participant

  auto_strip_attributes :role

  validates :case_participant_id, uniqueness: { scope: :case_id }
  validates :role, inclusion: { in: ROLES }, allow_blank: true
end
