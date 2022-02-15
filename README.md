# Emerchantpay


## Compatibility

Rails 6.0


## Installation

    bundle install
    rake db:create db:migrate
    rake csv_import:user[filename]

## API For Genrate JWT

```ruby
curl -X POST \
  http://localhost:3000/api/v1/users/authenticate \
  -H 'cache-control: no-cache' \
  -H 'content-type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW' \
  -H 'postman-token: 90d3ada2-9792-3e3b-e9cc-385763c695d3' \
  -F 'user[email]=test@yopmail.com' \
  -F 'user[password]=12345678'
```

## API For create Transactions

## API For create Authorize

```ruby
curl -X POST \
  http://localhost:3000/api/v1/transactions/authorize \
  -H 'authorization: Barer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyMSwiZXhwIjoxNTkxMjQ2NDkxLCJ1c2VyX3R5cGUiOiJVc2VyIn0.CXK6rKI1-1OHQnm0v_FMVu9pVID9ItVPZuqU_bOCVJo' \
  -H 'cache-control: no-cache' \
  -H 'content-type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW' \
  -H 'postman-token: 4e3cdea0-808d-b0d9-bbbb-5cc200e82ea7' \
  -F 'user[email]=test@yopmail.com' \
  -F 'user[password]=12345678'
```

## API For create Refund
```ruby
curl -X POST \
  http://localhost:3000/api/v1/transactions/c268fd5a-55a7-4951-b239-1aefaee1ac5a/refund \
  -H 'authorization: Barer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyMSwiZXhwIjoxNTkxMjQ2NDkxLCJ1c2VyX3R5cGUiOiJVc2VyIn0.CXK6rKI1-1OHQnm0v_FMVu9pVID9ItVPZuqU_bOCVJo' \
  -H 'cache-control: no-cache' \
  -H 'content-type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW' \
  -H 'postman-token: 044f450e-4f52-62f7-ad2b-256815a3e106' \
  -F 'transaction[amount]=12000' \
  -F 'transaction[customer_email]=12345678' \
  -F 'transaction[customer_phone]=email@yopmmail.com'
```

## Strategy

* After a transaction is authorised, the charge is created.
* After the amount is successfully deducted from merchant’s account the “status” of authorise and charge transactions is changed to “approved”
* If the Authorize transaction is invalidated, a reversal transaction is created. The status of that authorize transaction is set to reversal while the status of that reversal transaction is set to approved
* **Note**:  The flow for the  transaction with status “ error” was not clear to me.
* I tried to use [trailblazer](http://trailblazer.to/gems/operation/2.0/) this gem having capability issue with rails 6

