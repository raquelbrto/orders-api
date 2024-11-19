class UserPresenter 
  def initialize(user)
    @user = user
  end
    
  def show
    begin
      if !@user.is_a?(User) || @user.nil? || @user.blank? 
        not_found_message
      else
        { data: @user, status: 200 }
      end
    rescue StandardError => e
      Rails.logger.error("Error #{e.message}")
      error_message
    end
  end

  def show_all
    begin
      { data: @user, status: 200 }
    rescue StandardError => e
      Rails.logger.error("Error #{e.message}")
      error_message
    end
  end


  private
    def error_message
      { data: { error: 'Internal server error.' }, status:  500 }
    end

    def not_found_message
      { data: { message: 'User not found' }, status: 404 }
    end
end