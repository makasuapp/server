# typed: strict
class Wix::Contact
  extend T::Sig

  sig {returns(T.nilable(String))}
  attr_accessor :firstName
  sig {returns(T.nilable(String))}
  attr_accessor :lastName
  sig {returns(T.nilable(String))}
  attr_accessor :email
  sig {returns(T.nilable(String))}
  attr_accessor :phone

  sig {returns(T.nilable(String))}
  def first_name 
    @firstName
  end

  sig {returns(T.nilable(String))}
  def last_name 
    @lastName
  end

  sig {returns(T.untyped)}
  def to_params
    {
      first_name: @firstName,
      last_name: @lastName,
      email: @email,
      phone_number: @phone
    }
  end
end