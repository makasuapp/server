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
#  removed        :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  recipe_id      :bigint           not null
#
# Indexes
#
#  index_recipe_steps_on_recipe_id_and_removed  (recipe_id,removed)
#
class RecipeStep < ApplicationRecord
  extend T::Sig
  
  belongs_to :recipe
  #inputs in this step
  has_many :inputs, class_name: "StepInput", foreign_key: :recipe_step_id, dependent: :destroy
  has_and_belongs_to_many :tools
  has_and_belongs_to_many :detailed_instructions

  #steps where this is an input
  has_many :step_inputs, as: :inputable
  has_many :day_preps

  sig {returns(T.any(RecipeStep::ActiveRecord_Relation, RecipeStep::ActiveRecord_AssociationRelation))}
  def self.latest
    self.where(removed: false)
  end

  sig {returns(String)}
  def name
    if self.output_name.present?
      T.must(self.output_name)
    else
      "#{self.recipe.name} step #{self.number}"
    end
  end

  sig {params(for_date: T.any(DateTime, ActiveSupport::TimeWithZone)).returns(DateTime)}
  def min_needed_at(for_date)
    min_before = (self.min_before_sec || 0).seconds
    duration = (self.duration_sec || 0).seconds
    (for_date - (min_before + duration)).to_datetime
  end

  sig {void}
  def delete_step
    self.update_attributes(removed: true)
  end

  sig {params(params: T.any(
      T::Hash[Symbol, T.untyped],
      ActionController::Parameters
    )).returns(RecipeStep)}
  def update_step(params)
    step = self

    if self.removed
      raise "Unexpected updating an old step id=#{self.id}"
    end

    if (
      (params[:instruction] && params[:instruction] != self.instruction) ||
      params[:max_before_sec] != self.max_before_sec ||
      params[:min_before_sec] != self.min_before_sec ||
      (params[:number] && params[:number].to_i != self.number) ||
      params[:duration_sec] != self.duration_sec
    )
      step = self.dup
      step.instruction = params[:instruction] || self.instruction
      step.number = params[:number] || self.number 
      step.max_before_sec = params[:max_before_sec]
      step.min_before_sec = params[:min_before_sec]
      step.duration_sec = params[:duration_sec]
      step.save!

      self.update_attributes(removed: true)
    end

    step
  end
end
