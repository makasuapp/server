# typed: ignore
class Api::RecipesController < ApplicationController
  def index
    kitchen = Kitchen.find_by(id: params[:kitchen_id])
    @recipes = Recipe.where(organization_id: kitchen.organization_id)
    render formats: :json
  end
end