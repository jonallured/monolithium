# Plan for Removing Redis Dependency

## Current Redis Usage

### 1. Action Cable (WebSockets)
- The project uses ActionCable for real-time updates via WebSockets
- Redis is configured as the adapter for Action Cable in development and production
- Used by the `ArtsyViewerChannel` to broadcast lineup updates

### 2. Sidekiq (Background Jobs)
- Sidekiq is the configured job queue adapter for ActiveJob in both development and production
- Sidekiq depends on Redis for storing and managing its job queue
- Multiple background jobs are defined in the app/jobs directory
- Jobs are scheduled via rake tasks (every.rake) rather than Sidekiq's built-in scheduler

## Steps to Remove Redis Dependency

### 1. Replace Action Cable Adapter

**Use PostgreSQL Adapter**
- Action Cable officially supports PostgreSQL as an adapter since Rails 6.0
- This uses the existing database connection, simplifying infrastructure

```ruby
# config/cable.yml
development:
  adapter: postgresql

production:
  adapter: postgresql
```

Or to use a specific database configuration:

```ruby
# config/cable.yml
production:
  adapter: postgresql
  database: my_app_production
  pool: 5
  encoding: unicode
  url: <%= ENV.fetch("DATABASE_URL") %>
```

This approach leverages the built-in `postgresql` adapter that's included with Rails, so no extra gems are needed. Action Cable will create a `action_cable_channel_stream_references` and `action_cable_channel_stream_events` tables to manage subscriptions and broadcasting.

You can also run the built-in generator to set up the needed tables:

```bash
bin/rails generate channel_subscriptions
bin/rails db:migrate
```

### 2. Replace Sidekiq with Alternative Job Queue

There are two excellent PostgreSQL-backed options for ActiveJob: **Solid Queue** and **GoodJob**. Let's examine both:

#### Option A: Solid Queue (Rails Official)
- Officially maintained by the Rails team
- Added to Rails in version 7.1
- Designed to be simple and minimal with no external dependencies
- Focuses on core job processing without extra features

1. Add Solid Queue to your Gemfile:
```ruby
# Gemfile
# Remove these lines
# gem "redis"
# gem "sidekiq"

# Add this line
gem "solid_queue"
```

2. Generate and run migrations:
```bash
bin/rails generate solid_queue:install
bin/rails db:migrate
```

3. Configure ActiveJob to use Solid Queue:
```ruby
# config/environments/development.rb and production.rb
config.active_job.queue_adapter = :solid_queue
```

4. Configure Solid Queue (optional):
```ruby
# config/initializers/solid_queue.rb
Rails.application.config.solid_queue.concurrency = 5
Rails.application.config.solid_queue.polling_interval = 1.second

# For scheduled jobs, enable the scheduler process
Rails.application.config.solid_queue.pause_scheduler_when_congested = true
Rails.application.config.solid_queue.congestion_threshold = 50

# Set up custom error handling
Rails.application.config.solid_queue.on_error = ->(exception, job_class) do
  # Handle error (e.g., report to error tracking service)
  Rails.logger.error("Job error: #{exception.message}")
end
```

5. Configure the worker in Procfile:
```ruby
# Procfile
web: bundle exec puma -C config/puma.rb
worker: bundle exec rake solid_queue:start
```

6. For regular scheduled jobs, you need to use the recurring jobs API:
```ruby
# config/initializers/recurring_jobs.rb
Rails.application.config.after_initialize do
  # Register recurring jobs
  SolidQueue::RecurringExecution.register(
    "10-minute-job",
    "TenMinuteJob",
    {},  # arguments
    execution_mode: "async",
    schedule_mode: "every",
    interval: 10.minutes
  )
  
  SolidQueue::RecurringExecution.register(
    "hourly-job",
    "OneHourJob",
    {},
    execution_mode: "async",
    schedule_mode: "every",
    interval: 1.hour
  )
  
  SolidQueue::RecurringExecution.register(
    "daily-job",
    "OneDayJob",
    {},
    execution_mode: "async",
    schedule_mode: "cron",
    cron: "0 0 * * *"
  )
end
```

#### Option B: GoodJob
- More mature with a longer track record
- Rich feature set including dashboard, metrics, and more
- Built specifically for PostgreSQL with optimized queries
- Excellent concurrency and thread management

1. Add GoodJob to your Gemfile:
```ruby
# Gemfile
# Remove these lines
# gem "redis"
# gem "sidekiq"

# Add this line
gem "good_job"
```

2. Install and run migrations:
```bash
rails g good_job:install
rails db:migrate
```

3. Update ActiveJob configuration:
```ruby
# config/environments/development.rb and production.rb
config.active_job.queue_adapter = :good_job
```

4. Set up GoodJob configuration:
```ruby
# config/initializers/good_job.rb
GoodJob.configure do |config|
  # Execute jobs in their own thread pool
  config.execution_mode = :async_server
  
  # Number of threads to use for executing jobs
  config.max_threads = ENV.fetch("GOOD_JOB_MAX_THREADS", 5).to_i
  
  # How long to retain job records in the database (in days)
  config.job_record_retention = ENV.fetch("GOOD_JOB_RETENTION_PERIOD", 30).to_i

  # For time-based scheduling, GoodJob uses polling
  config.enable_cron = true
  config.cron = {
    # Example cron configuration (maps to our current every.rake tasks)
    ten_minutes: {
      cron: "*/10 * * * *",
      class: "TenMinuteJob"
    },
    hourly: {
      cron: "0 * * * *", 
      class: "OneHourJob"
    },
    daily: {
      cron: "0 0 * * *",
      class: "OneDayJob"
    }
  }
end
```

5. Update Procfile:
```ruby
# Procfile
web: bundle exec puma -C config/puma.rb
worker: bundle exec good_job start
```

#### Comparison: Solid Queue vs GoodJob

| Feature | Solid Queue | GoodJob |
|---------|-------------|---------|
| Maintainer | Rails core team | Independent |
| Integration | Built into Rails 7.1+ | External gem |
| Maturity | Newer (since 2023) | More mature (since 2020) |
| Features | Minimal, focused | Extensive (dashboard, metrics) |
| Scheduling | Multiple options (interval, cron) | Native cron support |
| Optimization | General database optimization | PostgreSQL-specific optimizations |
| UI Dashboard | No (would need separate tool) | Yes (built-in) |
| Documentation | Rails guides | Extensive GitHub docs |

**Recommendation**: Consider Solid Queue if you prefer official Rails integrations and simpler maintenance. Choose GoodJob if you want more features like a built-in dashboard or more mature PostgreSQL optimization.

### 3. Cache Store Configuration

Rails 7+ includes built-in support for PostgreSQL as a cache store:

```ruby
# config/environments/production.rb
config.cache_store = :postgres, 
  url: ENV['DATABASE_URL'],
  table_name: 'rails_cache', # Default is 'cache_entries'
  expires_in: 90.minutes

# For development
config.cache_store = :memory_store
```

The PostgreSQL cache store has some advantages over Redis:
- No extra service to manage or monitor
- Transactional integrity with your database
- Simpler deployment and scaling with just one database
- Built-in to Rails with no extra gems needed

For handling Rails session store (if you're using Redis for sessions):

```ruby
# config/initializers/session_store.rb
Rails.application.config.session_store :active_record_store, key: '_myapp_session'
```

Then run the session store migration:
```bash
rails generate active_record:session_migration
rails db:migrate
```

## Summary of Changes Required

1. **Gem Changes**:
   - Remove: `redis` and `sidekiq`
   - Add either: `solid_queue` (Rails official) or `good_job` (third-party)

2. **Configuration Changes**:
   - Update ActionCable adapter in `config/cable.yml` to use PostgreSQL
   - Update ActiveJob queue adapter in environment files to use chosen queue adapter
   - Create channel subscription tables for ActionCable
   - Configure job queue adapter with appropriate options (including scheduled jobs)
   - Set up PostgreSQL cache store for production 
   - Optionally set up ActiveRecord session store if needed

3. **Database Changes**:
   - Add database migrations for job queue tables (Solid Queue or GoodJob)
   - Run ActionCable channel subscriptions migration
   - Optionally add cache tables migration

4. **Deployment Changes**:
   - Update Procfile to replace Sidekiq worker with chosen job queue worker
   - Remove Redis from infrastructure requirements
   - Ensure database pool size is appropriate for increased PostgreSQL connections

## Potential Challenges

1. **Performance**: PostgreSQL may not match Redis performance for high-volume pub/sub operations or job queuing. PostgreSQL connection pools might need tuning.

2. **Database Load**: Moving ActionCable, background jobs, and possibly caching to PostgreSQL increases database load. Monitor and scale database resources accordingly.

3. **Job Scheduling**: Configuring scheduled jobs to match your current rake tasks scheduling with the new system (different approaches for Solid Queue vs GoodJob).

4. **Implementation Choice**: Deciding between Solid Queue (official Rails integration) and GoodJob (more features) will depend on your specific needs.

5. **Migration Process**: Consider implementing changes incrementally to minimize risks:
   - First migrate ActionCable to PostgreSQL
   - Then migrate background jobs to chosen queue adapter
   - Finally migrate cache store if needed

## Benefits

1. **Simplified Infrastructure**: With everything in PostgreSQL, you eliminate an entire system component (Redis), reducing operational complexity.

2. **Transactional Integrity**: PostgreSQL provides ACID compliance across all operations, which Redis doesn't.

3. **Unified Backup**: All data is in PostgreSQL, simplifying backup and recovery processes.

4. **Easier Development Setup**: Developers don't need to run Redis locally, simplifying development environment setup.