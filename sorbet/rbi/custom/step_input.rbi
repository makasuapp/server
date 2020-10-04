# typed: strong
class StepInput::ActiveRecord_Associations_CollectionProxy
  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def latest; end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def recipe_typed; end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def recipe_step_typed; end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def ingredient_typed; end
end

class StepInput::ActiveRecord_AssociationRelation
  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def latest; end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def recipe_typed; end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def recipe_step_typed; end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def ingredient_typed; end
end

class StepInput::ActiveRecord_Relation
  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def latest; end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def recipe_typed; end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def recipe_step_typed; end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def ingredient_typed; end
end