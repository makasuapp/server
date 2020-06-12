# typed: ignore
class Api::RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
    render formats: :json
  end
end