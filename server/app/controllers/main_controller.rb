class MainController < ApplicationController
  layout 'main'

  def index()
    @props = {
        authenticity_token: form_authenticity_token
    }
  end
end
