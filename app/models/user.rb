# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  name                   :string
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  address_id             :uuid
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id) ON DELETE => restrict
#
class User < ApplicationRecord
  NAME_MINIMUM_LENGTH = 2
  NAME_MAXIMUM_LENGTH = 32

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, :omniauthable

  belongs_to :address, optional: true

  has_one :attorney_profile, dependent: :destroy
  has_many :case_participants, dependent: :nullify
  has_many :created_cases,
           class_name: "Case",
           foreign_key: :created_by_id,
           dependent: :restrict_with_error,
           inverse_of: :created_by
  has_many :created_case_participants,
           class_name: "CaseParticipant",
           foreign_key: :created_by_id,
           dependent: :nullify,
           inverse_of: :created_by
  has_many :created_case_events,
           class_name: "CaseEvent",
           foreign_key: :created_by_id,
           dependent: :nullify,
           inverse_of: :created_by
  has_many :created_case_documents,
           class_name: "CaseDocument",
           foreign_key: :created_by_id,
           dependent: :nullify,
           inverse_of: :created_by

  auto_strip_attributes :name, :phone

  validates :name,
            presence: true,
            length: { minimum: NAME_MINIMUM_LENGTH, maximum: NAME_MAXIMUM_LENGTH },
            on: :create
end
