# This is an autogenerated file for dynamic methods in User
# Please rerun bundle exec rake rails_rbi:models[User] to regenerate.

# typed: strong
module User::ActiveRelation_WhereNot
  sig { params(opts: T.untyped, rest: T.untyped).returns(T.self_type) }
  def not(opts, *rest); end
end

module User::GeneratedAttributeMethods
  sig { returns(ActiveSupport::TimeWithZone) }
  def created_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def created_at=(value); end

  sig { returns(T::Boolean) }
  def created_at?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def current_sign_in_at; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def current_sign_in_at=(value); end

  sig { returns(T::Boolean) }
  def current_sign_in_at?; end

  sig { returns(T.nilable(T.untyped)) }
  def current_sign_in_ip; end

  sig { params(value: T.nilable(T.untyped)).void }
  def current_sign_in_ip=(value); end

  sig { returns(T::Boolean) }
  def current_sign_in_ip?; end

  sig { returns(String) }
  def email; end

  sig { params(value: T.any(String, Symbol)).void }
  def email=(value); end

  sig { returns(T::Boolean) }
  def email?; end

  sig { returns(String) }
  def encrypted_password; end

  sig { params(value: T.any(String, Symbol)).void }
  def encrypted_password=(value); end

  sig { returns(T::Boolean) }
  def encrypted_password?; end

  sig { returns(Integer) }
  def failed_attempts; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def failed_attempts=(value); end

  sig { returns(T::Boolean) }
  def failed_attempts?; end

  sig { returns(T.nilable(String)) }
  def first_name; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def first_name=(value); end

  sig { returns(T::Boolean) }
  def first_name?; end

  sig { returns(Integer) }
  def id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def id=(value); end

  sig { returns(T::Boolean) }
  def id?; end

  sig { returns(T.nilable(String)) }
  def last_name; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def last_name=(value); end

  sig { returns(T::Boolean) }
  def last_name?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def last_sign_in_at; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def last_sign_in_at=(value); end

  sig { returns(T::Boolean) }
  def last_sign_in_at?; end

  sig { returns(T.nilable(T.untyped)) }
  def last_sign_in_ip; end

  sig { params(value: T.nilable(T.untyped)).void }
  def last_sign_in_ip=(value); end

  sig { returns(T::Boolean) }
  def last_sign_in_ip?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def locked_at; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def locked_at=(value); end

  sig { returns(T::Boolean) }
  def locked_at?; end

  sig { returns(T.nilable(String)) }
  def phone_number; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def phone_number=(value); end

  sig { returns(T::Boolean) }
  def phone_number?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def remember_created_at; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def remember_created_at=(value); end

  sig { returns(T::Boolean) }
  def remember_created_at?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def reset_password_sent_at; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def reset_password_sent_at=(value); end

  sig { returns(T::Boolean) }
  def reset_password_sent_at?; end

  sig { returns(T.nilable(String)) }
  def reset_password_token; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def reset_password_token=(value); end

  sig { returns(T::Boolean) }
  def reset_password_token?; end

  sig { returns(Integer) }
  def sign_in_count; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def sign_in_count=(value); end

  sig { returns(T::Boolean) }
  def sign_in_count?; end

  sig { returns(T.nilable(String)) }
  def unlock_token; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def unlock_token=(value); end

  sig { returns(T::Boolean) }
  def unlock_token?; end

  sig { returns(ActiveSupport::TimeWithZone) }
  def updated_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def updated_at=(value); end

  sig { returns(T::Boolean) }
  def updated_at?; end
end

module User::GeneratedAssociationMethods
  sig { returns(::UserOrganization::ActiveRecord_Associations_CollectionProxy) }
  def user_organizations; end

  sig { returns(T::Array[Integer]) }
  def user_organization_ids; end

  sig { params(value: T::Enumerable[::UserOrganization]).void }
  def user_organizations=(value); end
end

module User::CustomFinderMethods
  sig { params(limit: Integer).returns(T::Array[User]) }
  def first_n(limit); end

  sig { params(limit: Integer).returns(T::Array[User]) }
  def last_n(limit); end

  sig { params(args: T::Array[T.any(Integer, String)]).returns(T::Array[User]) }
  def find_n(*args); end

  sig { params(id: Integer).returns(T.nilable(User)) }
  def find_by_id(id); end

  sig { params(id: Integer).returns(User) }
  def find_by_id!(id); end
end

class User < ApplicationRecord
  include User::GeneratedAttributeMethods
  include User::GeneratedAssociationMethods
  extend User::CustomFinderMethods
  extend User::QueryMethodsReturningRelation
  RelationType = T.type_alias { T.any(User::ActiveRecord_Relation, User::ActiveRecord_Associations_CollectionProxy, User::ActiveRecord_AssociationRelation) }
end

module User::QueryMethodsReturningRelation
  sig { returns(User::ActiveRecord_Relation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(User::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_Relation) }
  def except(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(User::ActiveRecord_Relation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: User::ActiveRecord_Relation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

module User::QueryMethodsReturningAssociationRelation
  sig { returns(User::ActiveRecord_AssociationRelation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(User::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(User::ActiveRecord_AssociationRelation) }
  def except(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(User::ActiveRecord_AssociationRelation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: User::ActiveRecord_AssociationRelation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

class User::ActiveRecord_Relation < ActiveRecord::Relation
  include User::ActiveRelation_WhereNot
  include User::CustomFinderMethods
  include User::QueryMethodsReturningRelation
  Elem = type_member(fixed: User)
end

class User::ActiveRecord_AssociationRelation < ActiveRecord::AssociationRelation
  include User::ActiveRelation_WhereNot
  include User::CustomFinderMethods
  include User::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: User)
end

class User::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include User::CustomFinderMethods
  include User::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: User)

  sig { params(records: T.any(User, T::Array[User])).returns(T.self_type) }
  def <<(*records); end

  sig { params(records: T.any(User, T::Array[User])).returns(T.self_type) }
  def append(*records); end

  sig { params(records: T.any(User, T::Array[User])).returns(T.self_type) }
  def push(*records); end

  sig { params(records: T.any(User, T::Array[User])).returns(T.self_type) }
  def concat(*records); end
end
