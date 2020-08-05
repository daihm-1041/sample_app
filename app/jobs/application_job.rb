class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe toignoreif the underlying records are nolongeravailable
  # discard_on ActiveJob::DeserializationError
end
