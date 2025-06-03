# Synchronization Service

This record Synchronization Service will consist of different components that will help build the whole application.

1. Synchronization Service - Which will handle syncing based on different actions happen in the Order table.
2. HTTP Client - This service will handle the API calling to the external service
3. Sidekiq - Background Job processing framework to control the jobs for Order events.
4. WebMock - This library is used to stub external services.

I want to solve the Synchronization problem with this whole setup.

- Created services to manage the API calls to the external service based on the record life cycle. i.e. create, update, delete.
- Created a sidekiq job to manage below stuff
  - Control the syncing to external services based on order_id. So one orde processed at a time.
  - Control the job processing by limiting.
  - Jobs will be queued and processed in the timely manner.
- Created http client with `Faraday` to handle the API calls to the external service.
  - It will handle all types of requests: `get`, `post`, `put`, and `delete`
  - It has set up with retry mechanism to retry in case of failures.
- Set up the WebMock to stub the request to external services
  - Stubbed all types of requests: `get`, `post`, `put`, and `delete`
  - Stubbed dummy response for each request

## Setup with Docker Compose

You can set up the whole module with Docker Compose for different use cases.

```bash
# This is the initial command to build the application image
# for different usages mentioned below
docker-compose build

# Create development database, run migration, and seed the Orders intothe  database
docker-compose run web bundle exec rake db:create db:migrate db:seed

# We can seed more Orders into the database with the below command
# Default 10000 Orders
docker-compose run web bundle exec rake db:seed

# You can customise the input for Orders creation
docker-compose run web bundle exec rake db:seed ORDER_COUNT=10000

# if you want to clean the Orders from database, recreate the Orders in the database
docker-compose run web bundle exec rake db:seed CLEAN_ORDERS='true' 

# You can use both env parameters as below
docker-compose run web bundle exec rake db:seed CLEAN_ORDERS='true' ORDER_COUNT=100

# Run the whole application at once with web application, sidekiq, PostgreSQL, Redis
docker-compose up --build

# Delete the whole setup if not required anymore
docker-compose down -v
```

