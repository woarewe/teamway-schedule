## Requriements

You can read the project requirements [here](./REQUIREMENTS.md)

## Dependecies

 - PostgreSQL 14.2
 - Ruby 3.1.3

## Setting up project locally

### Configuring database using Docker

```shell
docker pull postgres:14.2
docker volume create working_schedule
docker container create --name working_schedule --publish 5432:5432 --env POSTGRES_USER=postgres --env POSTGRES_PASSWORD=password --volume working_schedule:/var/lib/postgresql/data postgres:14.2
docker start working_schedule
```

### Setting ENV variables

```shell
cp .env.example .env
```

### Preparing databases

```shell
bin/rake db:create db:schema:load
```

### Checking tests, Rubocop and Zeitwerk

```shell
bin/rails test
bin/rubocop
bin/rails zeitwerk:check
```
