# typed: strict
# == Schema Information
#
# Table name: customers
#
#  id           :bigint           not null, primary key
#  email        :string
#  first_name   :string
#  last_name    :string
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_customers_on_email         (email)
#  index_customers_on_phone_number  (phone_number)
#
class Customer < ApplicationRecord
  extend T::Sig

  has_many :orders

  sig {params(phone_number: T.nilable(String), email: T.nilable(String),
    params: T.untyped).returns(Customer)}
  def self.assign_or_init_by_contact(phone_number, email, params)
    if phone_number.present?
      customer = Customer.find_by(phone_number: phone_number) 
    end

    if customer.nil? && email.present?
      customer = Customer.find_by(email: email)
    end

    if customer.nil?
      customer = Customer.new(params)
    else
      customer.assign_attributes(params)
    end

    customer
  end

  sig {returns(T.nilable(String))}
  def name
    if self.first_name.present?
      if self.last_name.present?
        "#{self.first_name} #{self.last_name}"
      else
        self.first_name
      end
    end
  end
end
