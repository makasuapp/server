# typed: false
class Wix::OrderItem
  extend T::Sig

  sig {void}
  def initialize
    @item_id = T.let("", String)
    @count = T.let(0, Integer)
    @price = T.let(0, Integer)
  end

  sig {returns(String)}
  attr_accessor :item_id
  sig {returns(Integer)}
  attr_accessor :count
  sig {returns(Integer)}
  attr_accessor :price
  sig {returns(T.nilable(String))}
  attr_accessor :comment
  sig {returns(T.nilable(T::Array[Wix::Variation]))}
  attr_accessor :variations
  sig {returns(T.nilable(T::Array[T.untyped]))}
  attr_accessor :variationsChoices

  sig {returns(T.nilable(T::Array[T::Array[Wix::VariationChoice]]))}
  def variation_choices
    if @variationsChoices.present?
      @variationsChoices.map { |choices| 
        Wix::VariationChoiceRepresenter.new([]).from_json(choices.to_json) }
    end
  end

  sig {returns(T::Hash[String, String])}
  def choice_to_variation_name
    name_map = {}

    if @variations.present?
      @variations.each do |variation|
        variation.item_ids.each do |item_id|
          name_map[item_id] = variation.name
        end
      end
    end

    name_map
  end
end