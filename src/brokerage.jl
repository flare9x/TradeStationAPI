
# Account
function get_accounts(access_token::String)::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/accounts"

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    # note can make sync
    response = HTTP.request("GET", api_endpoint, headers=headers)

    # parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # # index the JSON3.Object
    #res.Accounts[1].AccountID

    return res
end

# Get balances 
# 1 to 25 Account IDs can be specified, comma separated
function get_balances(access_token::String; accounts::String="61999124,68910124")::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/accounts"
    url = join(["$api_endpoint/$accounts/balances"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object
    #res.Balances[1].BalanceDetail.DayTradeExcess           

    return res
end


# Get balances BOD ( Beginning of Day)
# 1 to 25 Account IDs can be specified, comma separated
function get_balances_BOD(access_token::String; accounts::String="61999124,68910124")::JSON3.Object
    # API endpoint URL 
    api_endpoint = "https://api.tradestation.com/v3/brokerage/accounts"
    url = join(["$api_endpoint/$accounts/bodbalances"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object
    #res.BODBalances[1].CurrencyDetails[1].CashBalance
    #res.BODBalances[1].CurrencyDetails[1].CashBalance

    return res
end

# Get Historical Orders
function get_historical_orders(access_token::String; accounts::String="61999124,68910124", since::String="2023-12-01", pageSize::Any=nothing, nextToken::Any=nothing)::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/accounts"

    query_params = Dict(
        "since" => since,
        "pageSize" => pageSize,
        "nextToken" => nextToken
    )

    # Construct the full URL with path and query parameters
    full_url = "$api_endpoint/$accounts/historicalorders?" * join([string(key) * "=" * string(value) for (key, value) in query_params if value !== nothing], "&")

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", full_url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object
    #res.Orders

    return res
end

# Get Historical Orders By Order ID
function get_historical_orders_by_order_id(access_token::String; accounts::String="61999124,68910124", orderIds::String="123456789,6B29FC40-CA47-1067-B31D-00DD010662DA")::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/accounts"
    url = join(["$api_endpoint/$accounts/historicalorders/$orderIds?since=$since"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end


# Get orders
function get_orders(access_token::String; accounts::String="61999124,68910124", pageSize::Any=nothing, nextToken::Any=nothing)::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/accounts"

    query_params = Dict(
        "pageSize" => pageSize,
        "nextToken" => nextToken
    )

    # Construct the full URL with path and query parameters
    full_url = "$api_endpoint/$accounts/orders?" * join([string(key) * "=" * string(value) for (key, value) in query_params if value !== nothing], "&")

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", full_url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end

# Get orders by order id
function get_orders_by_order_id(access_token::String; accounts::String="61999124,68910124", orderIds::String="123456789,6B29FC40-CA47-1067-B31D-00DD010662DA")::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/accounts"
    url = join(["$api_endpoint/$accounts/orders/$orderIds"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end

# Get positions
function get_positions(access_token::String; accounts::String="61999124,68910124", symbol::String="symbol=MSFT,MSFT *")::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/accounts"
    url = join(["$api_endpoint/$accounts/positions?symbol=$symbol"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end


# get wallets
function get_wallets(access_token::String; account::String="61999124C")::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/accounts"
    url = join(["$api_endpoint/$account/wallets"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end


# get wallets
function stream_wallets(access_token::String; account::String="61999124C")::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/stream/accounts"
    url = join(["$api_endpoint/$account/wallets"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end


# get orders
function stream_orders(access_token::String; accountIds::String="61999124C")::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/stream/accounts"
    url = join(["$api_endpoint/$accountIds/orders"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end


# get orders by id
function stream_orders_by_id(access_token::String; accountIds::String="61999124C", orderIds::String="123456789,6B29FC40-CA47-1067-B31D-00DD010662DA")::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/stream/accounts"
    url = join(["$api_endpoint/$accountIds/orders/$orderIds"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end

# stream positions
function stream_positions(access_token::String; accountIds::String="61999124C", changes::Bool=false)::JSON3.Object
    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/brokerage/stream/accounts"
    url = join(["$api_endpoint/$accountIds/positions?changes=$changes"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    # Make the GET request
    response = HTTP.request("GET", url, headers=headers)

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    # index the JSON3.Object

    return res
end