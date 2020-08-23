module RelationshipsHelper
  def current_followed_user
    current_user.active_relationships.find_by followed_id: @user.id
  end
end
