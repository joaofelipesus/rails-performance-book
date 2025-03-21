# frozen_string_literal: true

namespace :customers do
  desc 'Reset customer rentals counter cache'
  task reset_customer_count: :environment do
    Customer.all.each do |customer|
      Customer.reset_counters(customer.id, :rentals)
    end
  end
end
