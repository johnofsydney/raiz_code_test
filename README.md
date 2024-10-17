# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

```
$ curl -X POST http://localhost:3000/users/sign_in \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{"email": "tom@money.com", "password": "foo"}'

{"user_id":8,"token":"OA=="}
```

```
$ curl -X POST http://localhost:3000/users/8/send_funds \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{"token": "OA==", "receiver_email": "sally@money.com", "amount": 3}'

{"success":true,"balance":9993}
```
