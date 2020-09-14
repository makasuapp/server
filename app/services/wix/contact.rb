# typed: strict
class Wix::Contact
  extend T::Sig

  sig {returns(T.nilable(String))}
  attr_accessor :first_name
  sig {returns(T.nilable(String))}
  attr_accessor :last_name
  sig {returns(T.nilable(String))}
  attr_accessor :email
  sig {returns(T.nilable(String))}
  attr_accessor :phone

  sig {returns(T.untyped)}
  def to_params
    {
      first_name: @first_name,
      last_name: @last_name,
      email: @email,
      phone_number: @phone
    }
  end
end