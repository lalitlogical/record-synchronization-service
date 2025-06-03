class SyncingJob
  include Sidekiq::Job

  def perform(order_id, action)
    synchronization_service = SynchronizationService.new(order_id, action)
    synchronization_service.synchronize
  end
end
