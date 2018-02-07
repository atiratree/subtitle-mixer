class MainController < ApplicationController
  layout "main"

  def index()
    @main_props = {
        authenticity_token: form_authenticity_token
    }
  end
end
