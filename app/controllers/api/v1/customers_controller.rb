class Api::V1::CustomersController < ApplicationController
  def index
    render json: Customer.all.map { |c| Api::V1::CustomerPresenter.new(c).to_json }
  end

  def timeline
    customer = Customer.find(params[:customer_id])
    rentals = Rental.where(id: Rails.cache.read(customer.timeline_cache_key))

    render json: rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  def rentals
    @customer = Customer.find params[:customer_id]
    render json: @customer.rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end
end
