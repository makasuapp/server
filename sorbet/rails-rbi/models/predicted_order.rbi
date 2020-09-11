# This is an autogenerated file for dynamic methods in PredictedOrder
# Please rerun bundle exec rake rails_rbi:models[PredictedOrder] to regenerate.

# typed: strong
module PredictedOrder::ActiveRelation_WhereNot
  sig { params(opts: T.untyped, rest: T.untyped).returns(T.self_type) }
  def not(opts, *rest); end
end

module PredictedOrder::GeneratedAttributeMethods
  sig { returns(ActiveSupport::TimeWithZone) }
  def created_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def created_at=(value); end

  sig { returns(T::Boolean) }
  def created_at?; end

  sig { returns(ActiveSupport::TimeWithZone) }
  def date; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def date=(value); end

  sig { returns(T::Boolean) }
  def date?; end

  sig { returns(Integer) }
  def id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def id=(value); end

  sig { returns(T::Boolean) }
  def id?; end

  sig { returns(Integer) }
  def kitchen_id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def kitchen_id=(value); end

  sig { returns(T::Boolean) }
  def kitchen_id?; end

  sig { returns(Integer) }
  def quantity; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def quantity=(value); end

  sig { returns(T::Boolean) }
  def quantity?; end

  sig { returns(Integer) }
  def recipe_id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def recipe_id=(value); end

  sig { returns(T::Boolean) }
  def recipe_id?; end

  sig { returns(ActiveSupport::TimeWithZone) }
  def updated_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def updated_at=(value); end

  sig { returns(T::Boolean) }
  def updated_at?; end
end

module PredictedOrder::GeneratedAssociationMethods
  sig { returns(::Kitchen) }
  def kitchen; end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::Kitchen).void)).returns(::Kitchen) }
  def build_kitchen(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::Kitchen).void)).returns(::Kitchen) }
  def create_kitchen(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::Kitchen).void)).returns(::Kitchen) }
  def create_kitchen!(*args, &block); end

  sig { params(value: ::Kitchen).void }
  def kitchen=(value); end

  sig { returns(::Recipe) }
  def recipe; end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::Recipe).void)).returns(::Recipe) }
  def build_recipe(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::Recipe).void)).returns(::Recipe) }
  def create_recipe(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::Recipe).void)).returns(::Recipe) }
  def create_recipe!(*args, &block); end

  sig { params(value: ::Recipe).void }
  def recipe=(value); end
end

module PredictedOrder::CustomFinderMethods
  sig { params(limit: Integer).returns(T::Array[PredictedOrder]) }
  def first_n(limit); end

  sig { params(limit: Integer).returns(T::Array[PredictedOrder]) }
  def last_n(limit); end

  sig { params(args: T::Array[T.any(Integer, String)]).returns(T::Array[PredictedOrder]) }
  def find_n(*args); end

  sig { params(id: Integer).returns(T.nilable(PredictedOrder)) }
  def find_by_id(id); end

  sig { params(id: Integer).returns(PredictedOrder) }
  def find_by_id!(id); end
end

class PredictedOrder < ApplicationRecord
  include PredictedOrder::GeneratedAttributeMethods
  include PredictedOrder::GeneratedAssociationMethods
  extend PredictedOrder::CustomFinderMethods
  extend PredictedOrder::QueryMethodsReturningRelation
  RelationType = T.type_alias { T.any(PredictedOrder::ActiveRecord_Relation, PredictedOrder::ActiveRecord_Associations_CollectionProxy, PredictedOrder::ActiveRecord_AssociationRelation) }
end

module PredictedOrder::QueryMethodsReturningRelation
  sig { returns(PredictedOrder::ActiveRecord_Relation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(PredictedOrder::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_Relation) }
  def except(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(PredictedOrder::ActiveRecord_Relation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: PredictedOrder::ActiveRecord_Relation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

module PredictedOrder::QueryMethodsReturningAssociationRelation
  sig { returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(PredictedOrder::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def except(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(PredictedOrder::ActiveRecord_AssociationRelation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: PredictedOrder::ActiveRecord_AssociationRelation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

class PredictedOrder::ActiveRecord_Relation < ActiveRecord::Relation
  include PredictedOrder::ActiveRelation_WhereNot
  include PredictedOrder::CustomFinderMethods
  include PredictedOrder::QueryMethodsReturningRelation
  Elem = type_member(fixed: PredictedOrder)
end

class PredictedOrder::ActiveRecord_AssociationRelation < ActiveRecord::AssociationRelation
  include PredictedOrder::ActiveRelation_WhereNot
  include PredictedOrder::CustomFinderMethods
  include PredictedOrder::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: PredictedOrder)
end

class PredictedOrder::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include PredictedOrder::CustomFinderMethods
  include PredictedOrder::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: PredictedOrder)

  sig { params(records: T.any(PredictedOrder, T::Array[PredictedOrder])).returns(T.self_type) }
  def <<(*records); end

  sig { params(records: T.any(PredictedOrder, T::Array[PredictedOrder])).returns(T.self_type) }
  def append(*records); end

  sig { params(records: T.any(PredictedOrder, T::Array[PredictedOrder])).returns(T.self_type) }
  def push(*records); end

  sig { params(records: T.any(PredictedOrder, T::Array[PredictedOrder])).returns(T.self_type) }
  def concat(*records); end
end
