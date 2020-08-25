# typed: ignore
class Api::RecipesController < ApplicationController
  def index
    @recipes = Recipe.where(kitchen_id: params[:kitchen_id])
    render formats: :json
  end
end