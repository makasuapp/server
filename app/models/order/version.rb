# typed: false
# == Schema Information
#
# Table name: order_versions
#
#  id         :bigint           not null, primary key
#  event      :string           not null
#  item_type  :string           not null
#  object     :text
#  whodunnit  :string
#  created_at :datetime
#  item_id    :bigint           not null
#
# Indexes
#
#  index_order_versions_on_item_type_and_item_id  (item_type,item_id)
#
class Order::Version < PaperTrail::Version
  self.table_name = :order_versions
end
