class AboutController < ApplicationController
  before_filter :authenticate_user!

  layout "medical_cases"
  def index

  end
end
