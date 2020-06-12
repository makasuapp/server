# typed: false
ActiveAdmin.register PurchasedRecipe do
  permit_params :date, :quantity, :recipe_id

  index do
    selectable_column
    id_column
    column :name do |pr|
      pr.recipe.name 
    end
    column :date
    column :quantity
    actions
  end

  filter :date, as: :date_range

  form do |f|
    f.inputs do
      f.input :date, as: :datepicker
      f.input :quantity
      f.input :recipe_id, as: :select, 
        collection: Recipe.published.map {|r| [r.name, r.id]}
    end
    f.actions
  end
end
