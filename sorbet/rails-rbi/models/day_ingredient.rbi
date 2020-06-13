# This is an autogenerated file for dynamic methods in DayIngredient
# Please rerun bundle exec rake rails_rbi:models[DayIngredient] to regenerate.

# typed: strong
module DayIngredient::ActiveRelation_WhereNot
  sig { params(opts: T.untyped, rest: T.untyped).returns(T.self_type) }
  def not(opts, *rest); end
end

module DayIngredient::GeneratedAttributeMethods
  sig { returns(ActiveSupport::TimeWithZone) }
  def created_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def created_at=(value); end

  sig { returns(T::Boolean) }
  def created_at?; end

  sig { returns(Float) }
  def expected_qty; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def expected_qty=(value); end

  sig { returns(T::Boolean) }
  def expected_qty?; end

  sig { returns(T.nilable(Float)) }
  def had_qty; end

  sig { params(value: T.nilable(T.any(Numeric, ActiveSupport::Duration))).void }
  def had_qty=(value); end

  sig { returns(T::Boolean) }
  def had_qty?; end

  sig { returns(Integer) }
  def id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def id=(value); end

  sig { returns(T::Boolean) }
  def id?; end

  sig { returns(Integer) }
  def ingredient_id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def ingredient_id=(value); end

  sig { returns(T::Boolean) }
  def ingredient_id?; end

  sig { returns(Integer) }
  def op_day_id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def op_day_id=(value); end

  sig { returns(T::Boolean) }
  def op_day_id?; end

  sig { returns(T.nilable(String)) }
  def unit; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def unit=(value); end

  sig { returns(T::Boolean) }
  def unit?; end

  sig { returns(ActiveSupport::TimeWithZone) }
  def updated_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def updated_at=(value); end

  sig { returns(T::Boolean) }
  def updated_at?; end
end

module DayIngredient::GeneratedAssociationMethods
  sig { returns(::Ingredient) }
  def ingredient; end

  sig { params(value: ::Ingredient).void }
  def ingredient=(value); end

  sig { returns(::OpDay) }
  def op_day; end

  sig { params(value: ::OpDay).void }
  def op_day=(value); end
end

module DayIngredient::CustomFinderMethods
  sig { params(limit: Integer).returns(T::Array[DayIngredient]) }
  def first_n(limit); end

  sig { params(limit: Integer).returns(T::Array[DayIngredient]) }
  def last_n(limit); end

  sig { params(args: T::Array[T.any(Integer, String)]).returns(T::Array[DayIngredient]) }
  def find_n(*args); end

  sig { params(id: Integer).returns(T.nilable(DayIngredient)) }
  def find_by_id(id); end

  sig { params(id: Integer).returns(DayIngredient) }
  def find_by_id!(id); end
end

class DayIngredient < ApplicationRecord
  include DayIngredient::GeneratedAttributeMethods
  include DayIngredient::GeneratedAssociationMethods
  extend DayIngredient::CustomFinderMethods
  extend DayIngredient::QueryMethodsReturningRelation
  RelationType = T.type_alias { T.any(DayIngredient::ActiveRecord_Relation, DayIngredient::ActiveRecord_Associations_CollectionProxy, DayIngredient::ActiveRecord_AssociationRelation) }
end

module DayIngredient::QueryMethodsReturningRelation
  sig { returns(DayIngredient::ActiveRecord_Relation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(DayIngredient::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_Relation) }
  def except(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(DayIngredient::ActiveRecord_Relation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: DayIngredient::ActiveRecord_Relation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

module DayIngredient::QueryMethodsReturningAssociationRelation
  sig { returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(DayIngredient::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def except(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(DayIngredient::ActiveRecord_AssociationRelation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: DayIngredient::ActiveRecord_AssociationRelation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

class DayIngredient::ActiveRecord_Relation < ActiveRecord::Relation
  include DayIngredient::ActiveRelation_WhereNot
  include DayIngredient::CustomFinderMethods
  include DayIngredient::QueryMethodsReturningRelation
  Elem = type_member(fixed: DayIngredient)
end

class DayIngredient::ActiveRecord_AssociationRelation < ActiveRecord::AssociationRelation
  include DayIngredient::ActiveRelation_WhereNot
  include DayIngredient::CustomFinderMethods
  include DayIngredient::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: DayIngredient)
end

class DayIngredient::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include DayIngredient::CustomFinderMethods
  include DayIngredient::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: DayIngredient)

  sig { params(records: T.any(DayIngredient, T::Array[DayIngredient])).returns(T.self_type) }
  def <<(*records); end

  sig { params(records: T.any(DayIngredient, T::Array[DayIngredient])).returns(T.self_type) }
  def append(*records); end

  sig { params(records: T.any(DayIngredient, T::Array[DayIngredient])).returns(T.self_type) }
  def push(*records); end

  sig { params(records: T.any(DayIngredient, T::Array[DayIngredient])).returns(T.self_type) }
  def concat(*records); end
end
