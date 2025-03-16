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

**Switch to GoodJob (SQL-based Queue)**
- GoodJob is a multithreaded, Postgres-based, ActiveJob backend for Ruby on Rails
- Created specifically to avoid Redis dependency while maintaining reliability
- Executes jobs with Rails ActiveJob framework
- Fully compatible with standard ActiveJob features like retries, priorities, and scheduling

1. Remove Sidekiq gem and add GoodJob:
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
  
  # Maximum number of seconds a job may be worked on before it is interrupted
  config.max_cache = ENV.fetch("GOOD_JOB_MAX_CACHE", 10_000).to_i
  
  # Enable or disable preserving job records after they've been executed
  config.preserve_job_records = ENV.fetch("GOOD_JOB_PRESERVE_JOB_RECORDS", true)
  
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

5. Update Procfile to use GoodJob instead of Sidekiq:
```ruby
# Procfile
web: bundle exec puma -C config/puma.rb
worker: bundle exec good_job start
```

6. Remove Sidekiq initializer:
```bash
rm config/initializers/sidekiq.rb
```

7. Update your rake tasks to be compatible with GoodJob (optional):
```ruby
# lib/tasks/every.rake
# You might want to refactor this to work with GoodJob's cron system
# Or keep it as is for backward compatibility
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
   - Add: `good_job`

2. **Configuration Changes**:
   - Update ActionCable adapter in `config/cable.yml` to use PostgreSQL
   - Update ActiveJob queue adapter in environment files to use GoodJob
   - Create channel subscription tables for ActionCable
   - Configure GoodJob with appropriate options (including cron schedule)
   - Set up PostgreSQL cache store for production 
   - Optionally set up ActiveRecord session store if needed

3. **Database Changes**:
   - Add database migrations for GoodJob tables
   - Run ActionCable channel subscriptions migration
   - Optionally add cache tables migration

4. **Deployment Changes**:
   - Update Procfile to replace Sidekiq worker with GoodJob worker
   - Remove Redis from infrastructure requirements
   - Ensure database pool size is appropriate for ActionCable and GoodJob connections

## Potential Challenges

1. **Performance**: PostgreSQL may not match Redis performance for high-volume pub/sub operations or job queuing. PostgreSQL connection pools might need tuning.

2. **Database Load**: Moving ActionCable, background jobs, and possibly caching to PostgreSQL increases database load. Monitor and scale database resources accordingly.

3. **Job Scheduling**: GoodJob's cron system needs configuration to match your current rake tasks scheduling.

4. **Migration Process**: Consider implementing changes incrementally to minimize risks:
   - First migrate ActionCable to PostgreSQL
   - Then migrate background jobs to GoodJob
   - Finally migrate cache store if needed

## Benefits

1. **Simplified Infrastructure**: With everything in PostgreSQL, you eliminate an entire system component (Redis), reducing operational complexity.

2. **Transactional Integrity**: PostgreSQL provides ACID compliance across all operations, which Redis doesn't.

3. **Unified Backup**: All data is in PostgreSQL, simplifying backup and recovery processes.

4. **Easier Development Setup**: Developers don't need to run Redis locally, simplifying development environment setup.