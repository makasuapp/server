# typed: strong
class RecipeStep::ActiveRecord_Associations_CollectionProxy
  sig {returns(T.any(RecipeStep::ActiveRecord_Relation, RecipeStep::ActiveRecord_AssociationRelation))}
  def prep; end

  sig {returns(T.any(RecipeStep::ActiveRecord_Relation, RecipeStep::ActiveRecord_AssociationRelation))}
  def cook; end
end

class RecipeStep::ActiveRecord_AssociationRelation
  sig {returns(T.any(RecipeStep::ActiveRecord_Relation, RecipeStep::ActiveRecord_AssociationRelation))}
  def prep; end

  sig {returns(T.any(RecipeStep::ActiveRecord_Relation, RecipeStep::ActiveRecord_AssociationRelation))}
  def cook; end
end