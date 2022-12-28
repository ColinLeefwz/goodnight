# setup

## build the environment and database

```sh
$ bundle install
$ bin/rails db:create
$ bin/rails db:migrate
$ bin/rails db:seed
```

## start server

```sh
$ bin/rails server
```

# test

## Get followers

```sh
$ curl http://localhost:3000/api/v1/users/1/followers
```

## Get followings

```sh
$ curl http://localhost:3000/api/v1/users/1/followings
```

## Check if following

```sh
$ curl http://localhost:3000/api/v1/users/1/is_following\?id\=2
```

## Follow user

```sh
$ curl http://localhost:3000/api/v1/users/1/follow -XPUT -d 'id=2'
```

## Unfollow user

```sh
$ curl http://localhost:3000/api/v1/users/1/unfollow -XPUT -d 'id=2'
```

## Clock-in

```sh
$ curl http://localhost:3000/api/v1/users/1/clocked_in -XPOST
```

## Sleep Rank of followings in past week

```sh
$ curl http://localhost:3000/api/v1/users/1/sleep_rank
```

# OpenApi Schema

## Generate by swagger-cli

```sh
npx @apidevtools/swagger-cli validate docs/openapi.yml
npx @apidevtools/swagger-cli bundle docs/openapi.yml -o sample.json
```

## Confirm in swagger-editor

<img width="690" alt="image" src="https://user-images.githubusercontent.com/7455902/209760742-e1fbcb10-226e-40dc-8b4b-0dd5d18bc02a.png">
<img width="782" alt="image" src="https://user-images.githubusercontent.com/7455902/209760766-99f36ba4-5c2e-4025-9dea-288c6de30557.png">

https://editor.swagger.io/
