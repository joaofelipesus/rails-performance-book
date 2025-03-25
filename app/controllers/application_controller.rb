class ApplicationController < ActionController::Base
  private

  def cached_response(expiration_key)
    cache_key = request.path
    object = Rails.cache.fetch(cache_key)

    if object&.last&.fetch(:expiration_key) == expiration_key
      object.pop
      return object
    end

    object = yield
    object.push(expiration_key: expiration_key).tap do |object|
      Rails.cache.write(cache_key, object)
      object.pop
    end
  end
end
