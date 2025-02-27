function get_routes(access_token::String)
    # API endpoint URL
    api_endpoint = "$trading_api_url/orderexecution/routes"

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", api_endpoint, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end


# place order
# per the Tradestation documentation - all features are in this one function 
# there are other subsets of this function for varying cases such as market, limit only without extra conditions - see further along in the code
function place_order(access_token::String; OrderType::String="Market", AccountID::String="123456782", Symbol::String="MSFT", Quantity::String="10",
    TradeAction::String="BUY", TimeInForceDuration::Any=nothing, 
    TimeInForceExpiration::String="DAY", Route::Any=nothing,                                                                                                            # required
    RuleType::Any=nothing, MarketActivationRuleSymbol::Any=nothing, Predicate::Any=nothing, TriggerKey::Any=nothing, Price::Any=nothing, LogicOperator::Any=nothing,    # MarketActivationRules
    AddLiquidity::Any=nothing, AllOrNone::Any=nothing, BookOnly::Any=nothing, DiscretionaryPrice::Any=nothing,                                                          # AdvancedOptions
    NonDisplay::Any=nothing, PegValue::Any=nothing, ShowOnlyQuantity::Any=nothing, TimeUtcActivationRule::Any=nothing, TrailingStopQuantity::Any=nothing,
    TrailingStopPercent::Any=nothing, BuyingPowerWarning::Any=nothing, LegSymbol::Any=nothing, LegQuantity::Any=nothing, LegTradeAction::Any=nothing, LimitPrice::Any=nothing,
    OSOsOrders::Any=nothing, OSOsType::Any=nothing, OrderConfirmID::Any=nothing, StopPrice::Any=nothing)

    # API endpoint URL
    api_endpoint = "$trading_api_url/orderexecution/orders"

    # Define the query parameters
    payload = Dict(
        "AccountID" => AccountID, # required
        "Symbol" => Symbol, # required
        "Quantity" => Quantity, # required
        "OrderType" => OrderType, # required
        "TradeAction" => TradeAction, # required
        "TimeInForce" => Dict( # required
            "Duration" => TimeInForceDuration,
            "Expiration" => TimeInForceExpiration), #  ISO 8601 date standard
        "Route" => Route,
        "AdvancedOptions" => Dict(
            "AddLiquidity" => AddLiquidity, # Valid for Equities only.
            "AllOrNone" => AllOrNone, # Valid for Equities and Options.
            "BookOnly" => BookOnly, # Valid for Equities only.
            "DiscretionaryPrice" => DiscretionaryPrice, # Valid for Equities only.
           "MarketActivationRules" => Dict( # Does not apply to Crypto orders.
                                            "RuleType" => RuleType,
                                            "Symbol" => MarketActivationRuleSymbol,
                                            "Predicate" => Predicate,
                                            "TriggerKey" => TriggerKey,
                                            "Price" => Price,
                                            "LogicOperator" => LogicOperator
                                            ),
        "NonDisplay" => NonDisplay,
        "PegValue" => PegValue, # Valid for Equities only.
        "ShowOnlyQuantity" => ShowOnlyQuantity, # For Equities and Futures.
        "TimeActivationRules" => Dict(
            "TimeUtc" => TimeUtcActivationRule
            ),
        "TrailingStop" => Dict(
            "Quantity" => TrailingStopQuantity,
            "Percent" => TrailingStopPercent
        ),
        ),
        "BuyingPowerWarning" => BuyingPowerWarning,
        "Legs" => Dict(
            "Quantity" => LegQuantity,
            "Symbol" => LegSymbol,
            "TradeAction" => LegTradeAction
        ),
        "LimitPrice" => LimitPrice,
        "OSOs" => Dict(
            "Orders" => OSOsOrders,
            "Type" => OSOsType
        ),
        "OrderConfirmID" => OrderConfirmID,
        "StopPrice" => StopPrice
    )

    # traverse Dict remove pairs where value is nothing
    payload = JSON3.write(traverse_dict_remove_nothing(payload))

    # Define the headers with the Bearer token
    headers = Dict(
        "content-type" => "application/json",
        "Authorization" => "Bearer $access_token"
    )

    # GET request with the access token included in the Authorization header
    response = HTTP.post(api_endpoint, headers = headers, body = payload)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    return res
end


# Simple market order - no other conditions
function simple_market_order(access_token::String; AccountID::String="123456782", Symbol::String="MSFT", Quantity::String="10",
    TradeAction::String="BUY", TimeInForceDuration::String="DAY", TimeInForceExpiration::Any=nothing, Route::Any=nothing)

    # API endpoint URL
    api_endpoint = "$trading_api_url/orderexecution/orders"

    # Define the query parameters
    payload = Dict(
        "AccountID" => AccountID, # required
        "Symbol" => Symbol, # required
        "Quantity" => Quantity, # required
        "OrderType" => "Market", # required
        "TradeAction" => TradeAction, # required
        "TimeInForce" => Dict( # required
            "Duration" => TimeInForceDuration,
            "Expiration" => TimeInForceExpiration), #  ISO 8601 date standard
        "Route" => Route
    )

    # traverse Dict remove pairs where value is nothing
    payload = JSON3.write(traverse_dict_remove_nothing(payload))

    # Define the headers with the Bearer token
    headers = Dict(
        "content-type" => "application/json",
        "Authorization" => "Bearer $access_token"
    )

    # GET request with the access token included in the Authorization header
    response = HTTP.post(api_endpoint, headers = headers, body = payload)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    return res
end 


# Simple limit order - no other conditions
function simple_limit_order(access_token::String; AccountID::String="123456782", Symbol::String="MSFT", LimitPrice::String, Quantity::String="10",
    TradeAction::String="BUY", TimeInForceDuration::String="DAY", TimeInForceExpiration::Any=nothing, Route::Any=nothing)

    # API endpoint URL
    api_endpoint = "$trading_api_url/orderexecution/orders"

    # Define the query parameters
    payload = Dict(
        "AccountID" => AccountID, # required
        "Symbol" => Symbol, # required
        "Quantity" => Quantity, # required
        "OrderType" => "Limit", # required
        "TradeAction" => TradeAction, # required
        "TimeInForce" => Dict( # required
            "Duration" => TimeInForceDuration,
            "Expiration" => TimeInForceExpiration), #  ISO 8601 date standard
        "Route" => Route,
        "LimitPrice" => LimitPrice
    )

    # traverse Dict remove pairs where value is nothing
    payload = JSON3.write(traverse_dict_remove_nothing(payload))

    # Define the headers with the Bearer token
    headers = Dict(
        "content-type" => "application/json",
        "Authorization" => "Bearer $access_token"
    )

    # GET request with the access token included in the Authorization header
    response = HTTP.post(api_endpoint, headers = headers, body = payload)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    return res
end 


function simple_stop_limit_order(access_token::String; AccountID::String="123456782", Symbol::String="MSFT", StopPrice::String, LimitPrice::String, Quantity::String="10",
    TradeAction::String="BUY", TimeInForceDuration::String="DAY", TimeInForceExpiration::Any=nothing, Route::Any=nothing)

    # API endpoint URL
    api_endpoint = "$trading_api_url/orderexecution/orders"

    # Define the query parameters
    payload = Dict(
        "AccountID" => AccountID, # required
        "Symbol" => Symbol, # required
        "Quantity" => Quantity, # required
        "OrderType" => "StopLimit", # required
        "TradeAction" => TradeAction, # required
        "TimeInForce" => Dict( # required
            "Duration" => TimeInForceDuration,
            "Expiration" => TimeInForceExpiration), #  ISO 8601 date standard
        "Route" => Route,
        "StopPrice" => StopPrice,
        "LimitPrice" => LimitPrice
    )

    # traverse Dict remove pairs where value is nothing
    payload = JSON3.write(traverse_dict_remove_nothing(payload))

    # Define the headers with the Bearer token
    headers = Dict(
        "content-type" => "application/json",
        "Authorization" => "Bearer $access_token"
    )

    # GET request with the access token included in the Authorization header
    response = HTTP.post(api_endpoint, headers = headers, body = payload)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    return res
end 


function cancel_order(access_token::String, OrderID::String)

    # API endpoint URL
    api_endpoint = "$trading_api_url/orderexecution/orders/$OrderID"


    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # GET request with the access token included in the Authorization header
    response = HTTP.delete(api_endpoint, headers = headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    return res
end 


function stop_limit_bracket_order(access_token::String; AccountID::String="123456782", Symbol::String="MSFT", StopPrice::String, LimitPrice::String, Quantity::String="10",
    TradeAction::String="BUY", TPLimitPrice::String, SLStopPrice::String, TimeInForceDuration::String="DAY")

    # API endpoint URL
    api_endpoint = "$trading_api_url/orderexecution/orders"

    # Define the query parameters
    payload = Dict(
        "AccountID" => AccountID,
        "Symbol" => Symbol,
        "Quantity" => Quantity,
        #"OrderType" => "Limit",
        "OrderType" => "StopLimit", # required
        "LimitPrice" => LimitPrice,
        "StopPrice" => StopPrice,
        #"LimitPrice" => LimitPrice,
        "TradeAction" => TradeAction,
        "TimeInForce" => Dict("Duration" => TimeInForceDuration),
        "Route" => "Intelligent",
        "OSOs" => [
            Dict(
                "Type" => "BRK",
                "Orders" => [
                    Dict(
                        "AccountID" => AccountID,
                        "Symbol" => Symbol,
                        "Quantity" => Quantity,
                        "OrderType" => "Limit",
                        "LimitPrice" => TPLimitPrice,
                        "TradeAction" => "SELL",
                        "TimeInForce" => Dict("Duration" => TimeInForceDuration),
                        "Route" => "Intelligent"
                    ),
                    Dict(
                        "AccountID" => AccountID,
                        "Symbol" => Symbol,
                        "Quantity" => Quantity,
                        "OrderType" => "StopMarket",
                        "StopPrice" => SLStopPrice,
                        "TradeAction" => "SELL",
                        "TimeInForce" => Dict("Duration" => TimeInForceDuration),
                        "Route" => "Intelligent",
                        #"AdvancedOptions" => Dict(
                        #    "TrailingStop" => Dict("Percent" => "5.0")
                        #)
                    )
                ]
            )
        ]
    )

    # Convert the payload to JSON format
    json_payload = JSON3.write(payload)

    # Define the headers with the Bearer token
    headers = Dict(
        "content-type" => "application/json",
        "Authorization" => "Bearer $access_token"
    )

    # Send the POST request
    response = HTTP.post(api_endpoint, headers = headers, body = json_payload)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    return res
end 


function cancel_order(access_token::String, OrderID::String)

    # API endpoint URL
    api_endpoint = "$trading_api_url/orderexecution/orders/$OrderID"


    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # GET request with the access token included in the Authorization header
    response = HTTP.delete(api_endpoint, headers = headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    return res
end 


# bracket order here


# stop limit highr 
# stop limit TP 
# stop limit SL
#=

{
  "AccountID": "123456782",
  "TimeInForce": {
    "Duration": "GTC"
  },
  "Quantity": "10",
  "OrderType": "Limit",
  "Symbol": "MSFT",
  "TradeAction": "BUY",
  "Route": "Intelligent",
  "LimitPrice": "330",
  "OSOs": [
    {
      "Type": "BRK",
      "Orders": [
        {
          "AccountID": "123456782",
          "TimeInForce": {
            "Duration": "GTC"
          },
          "Quantity": "5",
          "OrderType": "StopMarket",
          "Symbol": "MSFT",
          "TradeAction": "SELL",
          "Route": "Intelligent",
          "StopPrice": "325"
        },
        {
          "AccountID": "123456782",
          "TimeInForce": {
            "Duration": "GTC"
          },
          "Quantity": "5",
          "OrderType": "Limit",
          "Symbol": "MSFT",
          "TradeAction": "SELL",
          "Route": "Intelligent",
          "LimitPrice": "335"
        }
      ]
    },

    =#
   