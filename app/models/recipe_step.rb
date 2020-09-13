# typed: strict
# == Schema Information
#
# Table name: recipe_steps
#
#  id             :bigint           not null, primary key
#  duration_sec   :integer
#  instruction    :text             not null
#  max_before_sec :integer
#  min_before_sec :integer
#  number         :integer          not null
#  output_name    :string
#  step_type      :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  recipe_id      :bigint           not null
#
# Indexes
#
#  index_recipe_steps_on_recipe_id  (recipe_id)
#  index_recipe_steps_on_step_type  (step_type)
#
module StepType
  Cook = "cook"
  Prep = "prep"
end

class RecipeStep < ApplicationRecord
  extend T::Sig
  
  validates :step_type, inclusion: { in: %w(cook prep), message: "%{value} is not a valid type" }

  belongs_to :recipe
  #inputs in this step
  has_many :inputs, class_name: "StepInput", foreign_key: :recipe_step_id, dependent: :destroy
  has_and_belongs_to_many :tools
  has_and_belongs_to_many :detailed_instructions

  #steps where this is an input
  has_many :step_inputs, as: :inputable
  has_many :day_preps

  sig {returns(T.any(RecipeStep::ActiveRecord_Relation, RecipeStep::ActiveRecord_AssociationRelation))}
  def self.prep
    self.where(step_type: StepType::Prep)
  end

  sig {returns(T.any(RecipeStep::ActiveRecord_Relation, RecipeStep::ActiveRecord_AssociationRelation))}
  def self.cook
    self.where(step_type: StepType::Cook)
  end

  sig {returns(String)}
  def name
    if self.output_name.present?
      T.must(self.output_name)
    else
      "#{self.recipe.name} #{self.step_type} step #{self.number}"
    end
  end

  sig {params(for_date: T.any(DateTime, ActiveSupport::TimeWithZone)).returns(DateTime)}
  def min_needed_at(for_date)
    (for_date - (self.min_before_sec || 0).seconds).to_datetime
  end
end
