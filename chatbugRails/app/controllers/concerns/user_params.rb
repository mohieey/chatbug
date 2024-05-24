module UserParams
  extend ActiveSupport::Concern

  def user_params
    user = {}
    user[:username] = params.require(:username)
    user[:password] = params.require(:password)

    user
  end
end
