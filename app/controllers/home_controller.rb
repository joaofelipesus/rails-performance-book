class HomeController < ApplicationController
  before_action :check_new_year, only: [:happy_new_year]

  caches_page :home
  caches_action :happy_new_year

  def home
  end

  def happy_new_year
  end

  private

  def check_new_year
    head :forbidden unless true
  end
end
