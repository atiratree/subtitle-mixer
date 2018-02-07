# frozen_string_literal: true
require 'json'

class ResultController < ApplicationController

  def mix
    print params['data']['sub1']
    @values = JSON.parse(params['data'])
  end
end
