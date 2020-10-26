# Assignment Info
You are going to make a working version of a product called InstaFlower. The app is used for flower spotting while hiking, traveling, etc. Users can check out different flowers, their details, and sightings as well as add their sightings. Think of it as Instagram, but only for flowers, with a list of flowers as well.

You will not need to implement the whole product. You can check what must be implemented to complete the assignment in the section Requirements. The assignment usually takes around a single workday.

# Requirements
You will build an API in Ruby on Rails for the mobile app. This app should represent your level of expertise and we trust that you will solve it yourself. You must be able to explain the decisions that you made while planning and developing this app. The backend API and mobile app communicate via JSON. The database can be PostgresSQL or MySQL.

The project must have a (local) git repository. Write your commit messages so it is clear what changes they contain. Your submitted folder should not contain files and folders that are defined in the git ignore file.

Anything that is not specifically written is up to you to decide. Keep it simple.

## Required
1. Create a new rails project
    - Create a new Ruby on Rails project, version 6.0.X.
2. User model
    - Create a basic user model (email, username, password)
3. Implement authentication
    - Backend API will communicate with the mobile app via JSON Web Token
    - Implement a simple JWT authentication service
Authorization header must contain Bearer token
4. Flower model
    - Create a flower model (name, image, description)
    - Image of the flower is an ActiveStorage attachment, stored in local dir
    - Create a seed, and populate the database with at least 10 random valid flowers
5. Sighting model
    - Create a sighting model (longitude, latitude, user reference, flower reference, image)
    - Image of the sighting is an ActiveStorage attachment, stored in local dir
6. Like model
    - Create a like model (user reference, sighting reference)
7. Service: random question
    - Create a new column 'question' on the sighting model
    - All the sightings that are created must call service/activity that will fetch a random question and store it to the sighting
    - To get a question you have to call https://opentdb.com/ and get a random question
    - Documentation is here: https://opentdb.com/api_config.php
    - In case of a timeout, create a background worker (use Sidekiq) that receives the sighting id and tries to get the   question 1 hour later. If that worker fails, no need to retry, let it fail.
## Scenarios
1. Implement the API code to satisfy the following criteria:
    - As an unregistered user, I can register
    - As a not logged in user I can log in (request the auth token)
    - As a not logged in user I can see list of flowers
    - As a not logged in user I can see a list of sightings for a particular flower
    - As a logged in user I can see list of flowers
    - As a logged in user I can see a list of sightings for a particular flower
    - As a logged in user I can create a sighting
    - As a logged in user I can like a sighting
    - As a logged in user I can destroy only my sightings
    - As a logged in user I can destroy only my likes
## Tests
- Write tests in RSpec that cover all of the above scenarios
## Readme
- In Readme write details on how to set up the project and steps needed to make it running, as if you send over the project to another developer, that does not know anything about the project, or to the client.