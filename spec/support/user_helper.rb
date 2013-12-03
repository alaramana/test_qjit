module UserHelper
  def create_user_with_invitation(save=true)
    invite       = Fabricate(:invite)
    user         = User.new(Fabricate.attributes_for(:user))
    # user.invitation_token = invite.invitation_token
    user.role_id = 3
    user.active  = true
    user.email   = invite.email
    user.save if save
    user
  end

  def create_admin_with_invitation(save=true)
    invite       = Fabricate(:invite,:role_id=>2)
    user         = User.new(Fabricate.attributes_for(:user))
    # user.invitation_token = invite.invitation_token
    user.role_id = invite.role_id
    user.active  = true
    user.email   = invite.email
    user.save if save
    user
  end

  def create_superadmin
    user             = User.new(Fabricate.attributes_for(:user))
    user.role_id     = 1
    user.active      = true
    user.forem_admin = true
    user.forem_state = "approved"
    user.save
    user
  end
end
