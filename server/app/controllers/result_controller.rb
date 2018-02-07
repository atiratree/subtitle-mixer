# frozen_string_literal: true

class ResultController < ApplicationController

  def mix
    print params['name']['name']
  end
end
