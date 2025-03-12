class StoresController < ApplicationController
  def show
    @store = Store.find(params[:id])
    @films = @store.films.includes(:language)
  end

  def index
    @stores = Store.all
  end
end
