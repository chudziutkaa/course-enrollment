
# Course Enrollment

A service that implements a simple Course Enrollment feature.

## Project setup

It is recommended to use Docker to set up the project.

Follow the instructions below:

```shell
docker-compose build
docker-compose run web rails db:setup
```

### Running the tests

To run all tests use command:

```shell
docker-compose run web rspec
```

To check the test coverage please type the below command in the application directory when all tests finish:

```shell
open coverage/index.html
```

### API documentation

To refresh the API documentation run the following command:

```shell
rake docs:generate
```

Make sure your server is running (`docker-compose up`). Then, visit:

```shell
http://localhost:3000/docs
```
