# typed: ignore
class Api::RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :update]

  def index
    kitchen = Kitchen.find_by(id: params[:kitchen_id])
    @recipes = Recipe.where(organization_id: kitchen.organization_id)
    render formats: :json
  end

  def create
    kitchen = Kitchen.find_by(id: params[:kitchen_id])

    @recipe = Recipe.new(base_recipe_params)
    @recipe.organization_id = kitchen.organization_id

    unless @recipe.save
      render json: @recipe.errors, status: :unprocessable_entity
      return
    end

    @recipe.update_components(recipe_params[:recipe_steps])

    render :show, status: :ok
  end

  def update
    need_update_recipe = RecipeSnapshot.would_differ?(@recipe, base_recipe_params)

    unless @recipe.update(base_recipe_params)
      render json: @recipe.errors, status: :unprocessable_entity
      return
    end

    @recipe.update_components(recipe_params[:recipe_steps], need_update_recipe)

    render :show, status: :ok
  end

  def show
  end

  private
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def base_recipe_params
    params.require(:recipe).permit(:current_price_cents, :name, :output_qty, 
      :output_volume_weight_ratio, :publish, :unit)
  end

  def recipe_params
    params.require(:recipe).permit(:current_price_cents, :name, :output_qty, 
      :output_volume_weight_ratio, :publish, :unit,
      recipe_steps: [:id, :instruction, :number, :duration_sec,
        :max_before_sec, :min_before_sec,
        inputs: [
          :id, :inputable_type, :inputable_id, :quantity, :unit
        ]
      ]
    )
  end
end