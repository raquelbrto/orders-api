class UserGateway
  def show(id)
    Rails.cache.fetch("user_#{id}", expires_in: 600.seconds) do
      User.find_by_id(id)
    end
  end

  def create(user_params)
    user = User.find_or_create_by(id: user_params["user_id"])
    edit_user(user, user_params)

    user.save ? user : user.errors
  end

  def show_all
    User.all
  end

  private

  def edit_user(user, user_params)
    user.name = user_params["name"]
  end
end
