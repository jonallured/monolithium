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
- Add the 'action_cable_postgresql_adapter' gem
- Configure Action Cable to use PostgreSQL instead of Redis

```ruby
# Gemfile
gem 'action_cable_postgresql_adapter'

# config/cable.yml
development:
  adapter: postgresql
  url: <%= ENV.fetch("DATABASE_URL") %>

production:
  adapter: postgresql
  url: <%= ENV.fetch("DATABASE_URL") %>
```

### 2. Replace Sidekiq with Alternative Job Queue

**Switch to GoodJob (SQL-based Queue)**
- Use the `:good_job` adapter for both development and production

1. Remove Sidekiq gem and add GoodJob:
```ruby
# Gemfile
# Remove these lines
# gem "redis"
# gem "sidekiq"

# Add this line
gem "good_job"
```

2. Update ActiveJob configuration:
```ruby
# config/environments/development.rb
config.active_job.queue_adapter = :good_job

# config/environments/production.rb
config.active_job.queue_adapter = :good_job
```

3. Set up GoodJob configuration:
```ruby
# config/initializers/good_job.rb
GoodJob.configure do |config|
  config.execution_mode = :async
  config.max_threads = 5
  config.poll_interval = 30 # seconds
end
```

4. Run the GoodJob migrations:
```bash
rails g good_job:install
rails db:migrate
```

5. Remove Sidekiq initializer:
```bash
rm config/initializers/sidekiq.rb
```

### 3. Cache Store Configuration

While not explicitly configured to use Redis in this project, if you want to ensure no Redis cache is used:

```ruby
# config/environments/production.rb
config.cache_store = :memory_store # For small deployments
# OR
config.cache_store = :file_store, Rails.root.join("tmp", "cache") # For larger deployments
```

For production, you might consider using a PostgreSQL-based cache:

```ruby
# Gemfile
gem "activerecord-postgres-cache"

# config/environments/production.rb
config.cache_store = :postgres_cache, { table_name: "rails_cache" }
```

## Summary of Changes Required

1. **Gem Changes**:
   - Remove: `redis` and `sidekiq`
   - Add: `good_job` and possibly `action_cable_postgresql_adapter`

2. **Configuration Changes**:
   - Update ActionCable adapter in `config/cable.yml`
   - Update ActiveJob queue adapter in environment files
   - Remove Sidekiq initializer
   - Add GoodJob initializer

3. **Database Changes**:
   - Add database migrations for GoodJob tables
   - Possibly add tables for ActionCable if using PostgreSQL adapter

4. **Deployment Changes**:
   - Update Procfile to remove Sidekiq worker and add GoodJob worker
   - Remove Redis from infrastructure requirements

## Potential Challenges

1. **Background Job Reliability**: Sidekiq with Redis is known for its reliability and performance. Alternative solutions might not be as battle-tested.

2. **Real-time Updates**: ActionCable with PostgreSQL adapter is less common than the Redis adapter and may require more configuration and testing.

3. **Job Scheduling**: If you're using Sidekiq's scheduling features, you'll need to implement an alternative (like the rake tasks you're already using).