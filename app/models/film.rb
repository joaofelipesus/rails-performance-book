class Film < ApplicationRecord
  has_many :inventories
  has_many :stores, through: :inventories
  has_many :rentals, through: :inventories

  belongs_to :language

  after_save :write_cache

  private

  def write_cache
    Rails.cache.write(
      "/api/v1/films",
      Film
        .all
        .map { |film| Api::V1::FilmPresenter.new(film).to_json }
        .append(expiration_key: "#{Film.count}-#{updated_at}"
      )
    )

    true
  end
end
