class Order < ApplicationRecord
  after_create :create_it_on_external_services
  after_update :update_it_on_external_services
  after_destroy :destroy_it_on_external_services

  def create_it_on_external_services
    SyncingJob.new.perform(id, "create")
  end

  def update_it_on_external_services
    SyncingJob.new.perform(id, "update")
  end

  def destroy_it_on_external_services
    SyncingJob.new.perform(id, "destroy")
  end

  def full_address
    "##{street_address}, #{city}, #{state} #{pincode}, #{country}"
  end
end
