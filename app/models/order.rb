class Order < ApplicationRecord
  after_create :create_it_on_external_services, unless: :skip_syncing
  after_update :update_it_on_external_services, unless: :skip_syncing
  after_destroy :destroy_it_on_external_services, unless: :skip_syncing

  attr_accessor :skip_syncing, :delivered_on

  def create_it_on_external_services
    SyncingJob.perform_async(id, "create")
  end

  def update_it_on_external_services
    SyncingJob.perform_async(id, "update")
  end

  def destroy_it_on_external_services
    SyncingJob.perform_async(id, "destroy")
  end

  def full_address
    add = []
    add << street_address if street_address.present?
    add << city if city.present?
    add << state if state.present?
    add << pincode if pincode.present?
    add << country if country.present?
    add.join(",")
  end
end
