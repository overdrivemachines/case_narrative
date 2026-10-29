# == Schema Information
#
# Table name: case_events
#
#  id            :uuid             not null, primary key
#  all_day       :boolean          default(FALSE), not null
#  confidential  :boolean          default(FALSE), not null
#  description   :text
#  ends_at       :datetime
#  event_type    :string(40)       not null
#  location      :string(180)
#  metadata      :jsonb            not null
#  source        :string(180)
#  starts_at     :datetime         not null
#  status        :string(32)       default("scheduled"), not null
#  title         :string(180)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  case_id       :uuid             not null
#  created_by_id :uuid
#
# Foreign Keys
#
#  fk_rails_...  (case_id => cases.id) ON DELETE => cascade
#  fk_rails_...  (created_by_id => users.id) ON DELETE => nullify
#
class CaseEvent < ApplicationRecord
  EVENT_TYPES = %w[
    incident filing hearing trial deposition meeting communication deadline order judgment arrest
    investigation discovery mediation settlement other
  ].freeze
  STATUSES = %w[scheduled completed cancelled continued missed tentative].freeze

  belongs_to :case
  belongs_to :created_by, class_name: "User", optional: true

  auto_strip_attributes :event_type, :title, :description, :location, :status, :source

  validates :event_type, :title, :starts_at, :status, presence: true
  validates :event_type, inclusion: { in: EVENT_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :title, :location, :source, length: { maximum: 180 }, allow_blank: true

  validate :ends_at_is_not_before_starts_at

  private

  def ends_at_is_not_before_starts_at
    return if ends_at.blank? || starts_at.blank? || ends_at >= starts_at

    errors.add(:ends_at, "cannot be before the start time")
  end
end
