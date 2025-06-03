require "webmock"
include WebMock::API

WebMock.enable!

stub_request(:get, "#{EXTERNAL_HOST}/v1/orders").
  with(
    headers: {
      "Accept"=>"*/*",
      "Authorization"=>/Bearer \w+/,
      "Content-Type"=>"application/json"
    }).
  to_return(status: 200, body: [ { status: "something", purchased_date: "any date", delivery_date: "any date", cost: "any cost", address: "any address" } ].to_json, headers: {})

stub_request(:post, "#{EXTERNAL_HOST}/v1/orders").
  with(
    # body: :any,
    headers: {
      "Accept"=>"*/*",
      "Authorization"=>/Bearer \w+/,
      "Content-Type"=>"application/json"
    }).
  to_return(status: 200, body: { message: "Order was successfully created." }.to_json, headers: {})

stub_request(:put, %r{\A#{Regexp.escape(EXTERNAL_HOST)}/v1/orders/[0-9]+\z}).
  with(
    # body: /{"status"=>".*?", "purchased_date"=>".*?", "delivery_date"=>".*?", "cost"=>[0-9]+, "address"=>".*?"}/,
    headers: {
      "Accept"=>"*/*",
      "Authorization"=>/Bearer \w+/,
      "Content-Type"=>"application/json"
    }).
  to_return(status: 200, body: { message: "Order was successfully updated." }.to_json, headers: {})

stub_request(:delete, %r{\A#{Regexp.escape(EXTERNAL_HOST)}/v1/orders/[0-9]+\z}).
  with(
    headers: {
      "Accept"=>"*/*",
      "Authorization"=>/Bearer \w+/,
      "Content-Type"=>"application/json"
    }).
  to_return(status: 200, body: { message: "Order was successfully deleted." }.to_json, headers: {})
