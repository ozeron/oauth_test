class HomeController < ApplicationController
  def index
    redirect_to 'CropioApp://{"token":"hey"}'
  end
end
