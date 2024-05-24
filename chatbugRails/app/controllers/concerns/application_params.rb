module ApplicationParams
  extend ActiveSupport::Concern

  def application_params
    application = {}
    application[:name] = params.require(:name)

    application
  end
end
