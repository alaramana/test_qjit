class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role_id == 1
      can :manage, :all
    elsif user.role_id == 2
      can :manage, :all
    elsif user.role_id == 3
      #   can :read, :all
      cannot :manage, [User, MedicalOrganization]
    end
  end
end
