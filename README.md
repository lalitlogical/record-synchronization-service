# Synchronization Service

This record Synchronization Service will consist for different components which will help to build the whole application.

1. Synchronization Service - Which will handle syncing based on different actions happens in Order table.
2. Http Client - This service will handle the API calling top external service
3. Sidekiq - Background Job processing framework to control the jobs for Order events.
4. WebMock - This library used to stub external services.

I want to solve the Synchronization problem with this whole setup.

- Created services to manage the API calling to external service based on record life cycle i.e. create, update, delete
- Created sidekiq job to manage below stuffs
  - Control the syncing to external services
  - Control the jobs processing with limiting
  - Jobs will be quequed and process with timely manner
- Created http client with `Faraday` to handle the API calling to external service.
  - It will handle all type of request `get`, `post`, `put` and `delete`
  - It has setup with retry mechanism to retry in case of failures.
- Setup the WebMock to stub the request to external services
  - Stubbed the all type of requests i.e. `get`, `post`, `put` and `delete`
  - Stubbed dummy response for each requests

## Setup with Docker Compose

You can setup the whole module with Docker Compose for different use cases.

```bash
# This is the intial command to build the application image
# for different usages mentioned below
docker-compose build

# Create development database, run migration and seed the Orders into database
docker-compose run web bundle exec rake db:create db:migrate db:seed

# We can seed more Orders into database with below command
# Default 10000 Orders
docker-compose run web bundle exec rake db:seed

# You can customise the input for Orders creation
docker-compose run web bundle exec rake db:seed ORDER_COUNT=10000

# if you want to clean the Orders from database, recreate the Orders into database
docker-compose run web bundle exec rake db:seed CLEAN_ORDERS='true' 

# You can use both env parameters as below
docker-compose run web bundle exec rake db:seed CLEAN_ORDERS='true' ORDER_COUNT=100

# Run whole application at once with web application, sidekiq, postgresql, redis
docker-compose up --build

# Delete whole setup if not required anymore
docker-compose down -v
```

