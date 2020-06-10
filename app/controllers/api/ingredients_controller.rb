#typed: false
class Api::IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.all
    render formats: :json
  end
end