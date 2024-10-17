# README

## Raiz code test by John Coote

First clone the repo locally and then

```
$ bundle install
$ rails db:setup
```

This will create 3 users, each with a wallet and some funds. Checkout `db/seeds.rb` for details.

In order to perform any actions, first sign in to get a token, as follows:

```sh
$ curl -X POST http://localhost:3000/users/sign_in \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{"email": "tom@money.com", "password": "foo"}'

{"token":"dZywFjmlBVGKZTlgcSDn129tXy5RAIyJYlgRne9ur95XMFZJckoOop/mQVVTCutjt90fBKYd--FqcCx7O/f2CcBbki--lIp/JK7Ll0J7p5Fx6pfHYw=="}
```

If the email and password are not a valid combination there should be a suitable error message:

```sh
$ curl -X POST http://localhost:3000/users/sign_in \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{"email": "tom@money.com", "password": "foot"}'

{"error":"unauthorized"}
```

Funds can be transferred to another user as follows;
The receiver_email nust correspond to a valid user (with a wallet), and there must be sufficient funds in the senders wallet.
The token identifies the current user.

```sh
$ curl -X POST http://localhost:3000/users/send_funds \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{"token": "6w==--3ezriAuCwUbkI1MY--AZcEkshZXZ7FXOZLbmgMmw==", "receiver_email": "sally@money.com", "amount": 45}'

{"success":true,"balance":9918}
```

If the requested amount is too high, then the error message will reflect that.

```sh
$ curl -X POST http://localhost:3000/users/send_funds \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{"token": "6w==--3ezriAuCwUbkI1MY--AZcEkshZXZ7FXOZLbmgMmw==", "receiver_email": "sally@money.com", "amount": 45678}'

{"success":false,"balance":9918}
```

The Stock Price getter is contained in the file `lib/stock_info.rb`
Calling like this for the requested methods will call to the external API and save the stock and the stock price into the database

```rb
StockInfo.price('AKUMDRUG.NS')
StockInfo.prices(['AKUMDRUG.NS', "HININDUS.NS", "ITC.NS"])
StockInfo.price_all
```
