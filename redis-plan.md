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

### 2. Replace Sidekiq with Solid Queue

Solid Queue is officially maintained by the Rails team and added to Rails in version 7.1. It's designed to be simple and minimal with no external dependencies, focusing on core job processing without extra features. Most importantly, it uses the same database connection as your Rails application by default.

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

This migration creates several tables in your PostgreSQL database:
- `solid_queue_jobs`: Stores job metadata
- `solid_queue_ready_executions`: Queue of jobs ready to run
- `solid_queue_scheduled_executions`: Jobs scheduled to run in the future
- `solid_queue_semaphores`: Locks to prevent race conditions
- `solid_queue_blocked_executions`: Jobs waiting for other jobs
- `solid_queue_claimed_executions`: Currently running jobs
- `solid_queue_recurring_executions`: Definitions for recurring jobs

3. Configure ActiveJob to use Solid Queue:
```ruby
# config/environments/development.rb and production.rb
config.active_job.queue_adapter = :solid_queue
```

4. Database Configuration:
Solid Queue automatically uses your Rails application's database configuration. No additional database configuration is required - it uses the same PostgreSQL connection defined in your `database.yml`.

If you need to customize the database connection:

```ruby
# config/initializers/solid_queue.rb
Rails.application.config.solid_queue.connect_to = 
  { database: ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: "job_queue") }
```

5. Configure Solid Queue performance options:
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

6. Configure the worker in Procfile:
```ruby
# Procfile
web: bundle exec puma -C config/puma.rb
worker: bundle exec rake solid_queue:start
```

7. For regular scheduled jobs, you need to use the recurring jobs API:
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
   - Add: `solid_queue`

2. **Configuration Changes**:
   - Update ActionCable adapter in `config/cable.yml` to use PostgreSQL
   - Update ActiveJob queue adapter in environment files to use Solid Queue
   - Create channel subscription tables for ActionCable
   - Configure Solid Queue with appropriate options (including scheduled jobs)
   - Set up PostgreSQL cache store for production 
   - Optionally set up ActiveRecord session store if needed

3. **Database Changes**:
   - Add database migrations for Solid Queue tables
   - Run ActionCable channel subscriptions migration
   - Optionally add cache tables migration

4. **Deployment Changes**:
   - Update Procfile to replace Sidekiq worker with Solid Queue worker
   - Remove Redis from infrastructure requirements
   - Ensure database pool size is appropriate for increased PostgreSQL connections

## Potential Challenges

1. **Performance**: PostgreSQL may not match Redis performance for high-volume pub/sub operations or job queuing. PostgreSQL connection pools might need tuning.

2. **Database Load**: Moving ActionCable, background jobs, and possibly caching to PostgreSQL increases database load. Monitor and scale database resources accordingly.

3. **Job Scheduling**: Configuring scheduled jobs to match your current rake tasks scheduling with the new Solid Queue system.

4. **Migration Process**: Consider implementing changes incrementally to minimize risks:
   - First migrate ActionCable to PostgreSQL
   - Then migrate background jobs to Solid Queue
   - Finally migrate cache store if needed

## Benefits

1. **Simplified Infrastructure**: With everything in PostgreSQL, you eliminate an entire system component (Redis), reducing operational complexity.

2. **Transactional Integrity**: PostgreSQL provides ACID compliance across all operations, which Redis doesn't.

3. **Unified Backup**: All data is in PostgreSQL, simplifying backup and recovery processes.

4. **Easier Development Setup**: Developers don't need to run Redis locally, simplifying development environment setup.