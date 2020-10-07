# typed: ignore
class Api::IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:update]

  def index
    @kitchen = Kitchen.find_by(id: params[:kitchen_id])

    set_ingredients

    render formats: :json
  end

  def create
    @kitchen = Kitchen.find_by(id: params[:kitchen_id])

    @ingredient = Ingredient.new(ingredient_params)
    @ingredient.organization_id = @kitchen.organization_id

    unless @ingredient.save
      render json: @ingredient.errors, status: :unprocessable_entity
      return
    end

    set_ingredients

    render :index, status: :ok
  end

  def update
    @kitchen = Kitchen.find_by(id: params[:kitchen_id])

    unless @ingredient.update(ingredient_params)
      render json: @ingredient.errors, status: :unprocessable_entity
      return
    end

    set_ingredients

    render :index, status: :ok
  end

  private
  def set_ingredients
    @ingredients = Ingredient.where(organization_id: @kitchen.organization_id).order("id ASC")
  end


  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :volume_weight_ratio, 
      :default_vendor_id)
  end
end