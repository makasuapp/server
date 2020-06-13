# typed: strong
class User < ApplicationRecord
  sig { returns(T.nilable(String)) }
  def role; end

  sig { params(value: T.nilable(T.any(Integer, String, Symbol))).void }
  def role=(value); end

  sig { returns(T::Boolean) }
  def role?; end
end