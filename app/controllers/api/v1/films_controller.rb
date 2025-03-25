class Api::V1::FilmsController < ApplicationController
  def lean
    render json: json_response
  end

  def index
    # render json: scope.map { |film| Api::V1::FilmPresenter.new(film).to_json }

    # render json: cached_index_response
    expiration_key = "#{Film.count}-#{Film.maximum(:updated_at)}"
    aux = cached_response(expiration_key) do
      scope.map { |film| Api::V1::FilmPresenter.new(film).to_json }
    end
    render json: aux
  end

  def rentals
    inventory_ids = Inventory.where(film_id: params[:film_id], store_id: params[:store_id]).pluck(:id)
    rentals = Rental.where(inventory_id: inventory_ids).includes(:film, :customer)

    render json: rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  private

  def json_response
    Film.pluck(:id, :title).map { |m| {id: m.first, title: m.last} }.to_json
  end

  def scope
    aux = if params[:store_id]
      @store = Store.find(params[:store_id])
      @store.films
    else
      Film
    end

    if params[:language]
      language = Language.where(name: params[:language]).first
      aux = Film.where(language_id: language.id).order("title asc")
    end

    aux.select(:id, :title, :updated_at)
  end

  # def cached_index_response
  #   cached_response do
  #     scope.map { |film| Api::V1::FilmPresenter.new(film).to_json }
  #   end
  # end

  # def cached_response
  #   cache_key = "films/index-cache"
  #   object = Rails.cache.fetch(cache_key)
  #   expiration_key = "#{Film.count}-#{Film.maximum(:updated_at)}"

  #   # If what we find on the cache layer is a Hash
  #   # and the expiration key in it is the same as the one we calculated
  #   # remove the expiration key and return it.
  #   if object&.last&.fetch(:expiration_key) == expiration_key
  #     object.pop
  #     return object
  #   end

  #   # If the object found on the cache is invalid
  #   # we execute the block so we calculate a new response,
  #   # we store on the cache layer with the expiration key mixed in it
  #   # and then we return it wihtout the expiration key so it can be rendered.
  #   yield.push(expiration_key: expiration_key).tap do |object|
  #     Rails.cache.write(cache_key, object)
  #     object.pop
  #   end
  # end
end
