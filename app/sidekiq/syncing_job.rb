class SyncingJob
  include Sidekiq::Job
  include Sidekiq::Throttled::Job

  sidekiq_options queue: :default

  sidekiq_throttle(
    # Allow maximum 10 concurrent jobs of this class at a time.
    concurrency: { limit: 10, key_suffix: ->(order_id, action) { order_id } },
    # Allow maximum 1K jobs being processed within one hour window.
    threshold: { limit: 1_000, period: 1.hour }
  )

  def perform(order_id, action)
    synchronization_service = SynchronizationService.new(order_id, action)
    synchronization_service.synchronize
  end
end
