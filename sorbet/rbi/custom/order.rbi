# typed: strong
class Order::ActiveRecord_Associations_CollectionProxy
  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone), timezone: String)
    .returns(T.any(Order::ActiveRecord_Relation, Order::ActiveRecord_AssociationRelation))}
  def on_date(date, timezone = "America/Toronto"); end
end

class Order::ActiveRecord_AssociationRelation
  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone), timezone: String)
    .returns(T.any(Order::ActiveRecord_Relation, Order::ActiveRecord_AssociationRelation))}
  def on_date(date, timezone = "America/Toronto"); end
end

class Order::ActiveRecord_Relation
  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone), timezone: String)
    .returns(T.any(Order::ActiveRecord_Relation, Order::ActiveRecord_AssociationRelation))}
  def on_date(date, timezone = "America/Toronto"); end
end