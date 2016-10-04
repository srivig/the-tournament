class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :embed, :all
      can :raw, :all
    end

    can :manage, User, id: user.id
    can :manage, Tournament, user_id: user.id
    can :manage, Game, tournament: { user_id: user.id }
    can :manage, Player, tournament: { user_id: user.id }
  end
end
