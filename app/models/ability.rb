# typed: ignore
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.manager?
      can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    end
  end
end
