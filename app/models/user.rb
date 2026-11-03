# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  address_line_1         :string
#  address_line_2         :string
#  city                   :string
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
#  postal_code            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("unapproved"), not null
#  sign_in_count          :integer          default(0), not null
#  state                  :string
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class User < ApplicationRecord
  NAME_MINIMUM_LENGTH = 2
  NAME_MAXIMUM_LENGTH = 32

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, :omniauthable

  auto_strip_attributes :name, :phone

  enum :role, %i[unapproved standard admin]

  validates :name,
            presence: true,
            length: { minimum: NAME_MINIMUM_LENGTH, maximum: NAME_MAXIMUM_LENGTH },
            on: :create
end
