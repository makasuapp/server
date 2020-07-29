# This is an autogenerated file for dynamic methods in OrderItem
# Please rerun bundle exec rake rails_rbi:models[OrderItem] to regenerate.

# typed: strong
module OrderItem::ActiveRelation_WhereNot
  sig { params(opts: T.untyped, rest: T.untyped).returns(T.self_type) }
  def not(opts, *rest); end
end

module OrderItem::GeneratedAttributeMethods
  sig { returns(ActiveSupport::TimeWithZone) }
  def created_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def created_at=(value); end

  sig { returns(T::Boolean) }
  def created_at?; end

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def done_at; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def done_at=(value); end

  sig { returns(T::Boolean) }
  def done_at?; end

  sig { returns(Integer) }
  def id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def id=(value); end

  sig { returns(T::Boolean) }
  def id?; end

  sig { returns(Integer) }
  def order_id; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def order_id=(value); end

  sig { returns(T::Boolean) }
  def order_id?; end

  sig { returns(Integer) }
  def price_cents; end

  sig { params(value: T.any(Numeric, ActiveSupport::Duration)).void }
  def price_cents=(value); end

  sig { returns(T::Boolean) }
  def price_cents?; end

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

  sig { returns(T.nilable(ActiveSupport::TimeWithZone)) }
  def started_at; end

  sig { params(value: T.nilable(T.any(Date, Time, ActiveSupport::TimeWithZone))).void }
  def started_at=(value); end

  sig { returns(T::Boolean) }
  def started_at?; end

  sig { returns(ActiveSupport::TimeWithZone) }
  def updated_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def updated_at=(value); end

  sig { returns(T::Boolean) }
  def updated_at?; end
end

module OrderItem::GeneratedAssociationMethods
  sig { returns(::Order) }
  def order; end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::Order).void)).returns(::Order) }
  def build_order(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::Order).void)).returns(::Order) }
  def create_order(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::Order).void)).returns(::Order) }
  def create_order!(*args, &block); end

  sig { params(value: ::Order).void }
  def order=(value); end

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

module OrderItem::CustomFinderMethods
  sig { params(limit: Integer).returns(T::Array[OrderItem]) }
  def first_n(limit); end

  sig { params(limit: Integer).returns(T::Array[OrderItem]) }
  def last_n(limit); end

  sig { params(args: T::Array[T.any(Integer, String)]).returns(T::Array[OrderItem]) }
  def find_n(*args); end

  sig { params(id: Integer).returns(T.nilable(OrderItem)) }
  def find_by_id(id); end

  sig { params(id: Integer).returns(OrderItem) }
  def find_by_id!(id); end
end

class OrderItem < ApplicationRecord
  include OrderItem::GeneratedAttributeMethods
  include OrderItem::GeneratedAssociationMethods
  extend OrderItem::CustomFinderMethods
  extend OrderItem::QueryMethodsReturningRelation
  RelationType = T.type_alias { T.any(OrderItem::ActiveRecord_Relation, OrderItem::ActiveRecord_Associations_CollectionProxy, OrderItem::ActiveRecord_AssociationRelation) }
end

module OrderItem::QueryMethodsReturningRelation
  sig { returns(OrderItem::ActiveRecord_Relation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(OrderItem::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_Relation) }
  def except(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(OrderItem::ActiveRecord_Relation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: OrderItem::ActiveRecord_Relation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

module OrderItem::QueryMethodsReturningAssociationRelation
  sig { returns(OrderItem::ActiveRecord_AssociationRelation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(OrderItem::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def select(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def except(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(OrderItem::ActiveRecord_AssociationRelation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: OrderItem::ActiveRecord_AssociationRelation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

class OrderItem::ActiveRecord_Relation < ActiveRecord::Relation
  include OrderItem::ActiveRelation_WhereNot
  include OrderItem::CustomFinderMethods
  include OrderItem::QueryMethodsReturningRelation
  Elem = type_member(fixed: OrderItem)
end

class OrderItem::ActiveRecord_AssociationRelation < ActiveRecord::AssociationRelation
  include OrderItem::ActiveRelation_WhereNot
  include OrderItem::CustomFinderMethods
  include OrderItem::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: OrderItem)
end

class OrderItem::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include OrderItem::CustomFinderMethods
  include OrderItem::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: OrderItem)

  sig { params(records: T.any(OrderItem, T::Array[OrderItem])).returns(T.self_type) }
  def <<(*records); end

  sig { params(records: T.any(OrderItem, T::Array[OrderItem])).returns(T.self_type) }
  def append(*records); end

  sig { params(records: T.any(OrderItem, T::Array[OrderItem])).returns(T.self_type) }
  def push(*records); end

  sig { params(records: T.any(OrderItem, T::Array[OrderItem])).returns(T.self_type) }
  def concat(*records); end
end
