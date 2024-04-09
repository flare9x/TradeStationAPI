
# Account
function get_accounts(access_token::String)::JSON3.Object
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/accounts"

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
function get_balances(access_token::String, accounts::String)::JSON3.Object
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/accounts"
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
function get_balances_BOD(access_token::String, accounts::String)::JSON3.Object
    # API endpoint URL 
    api_endpoint = "$trading_api_url/brokerage/accounts"
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
function get_historical_orders(access_token::String, accounts::String; since::String="2023-12-01", pageSize::Any=nothing, nextToken::Any=nothing)::JSON3.Object
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/accounts"

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
function get_historical_orders_by_order_id(access_token::String, accounts::String, orderIds::String, since::String)::JSON3.Object
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/accounts"
    #url = join(["$api_endpoint/$accounts/historicalorders/$orderIds?since=$since"])

    query_params = Dict(
        "since" => since
    )

    # Construct the full URL with path and query parameters
    full_url = "$api_endpoint/$accounts/historicalorders/$orderIds?" * join([string(key) * "=" * string(value) for (key, value) in query_params if value !== nothing], "&")


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

# Get orders
function get_orders(access_token::String, accounts::String; pageSize::Any=nothing, nextToken::Any=nothing)::JSON3.Object
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/accounts"

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
function get_orders_by_order_id(access_token::String, accounts::String, orderIds::String)::JSON3.Object
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/accounts"
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
function get_positions(access_token::String, accounts::String, symbol::String)::JSON3.Object
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/accounts"
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
function get_wallets(access_token::String, account::String)::JSON3.Object
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/accounts"
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
function stream_wallets(access_token::String, account::String)
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/stream/accounts"
    url = join(["$api_endpoint/$account/wallets"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    while true
        try
            HTTP.open("GET", url, headers=headers) do io
                startread(io)

                while !eof(io)
                    data = String(readavailable(io))

                    try
                        json_dict = JSON3.read(IOBuffer(data))
                        println(json_dict)
                    catch e
                        println("Error processing JSON: $e")
                    end
                end
            end
        catch e
            println("Error during HTTP request: $e")
        end

        println("Connection closed. Reconnecting...")
        sleep(1)  # Add a delay before attempting to reconnect
    end
end


# get orders
function stream_orders(access_token::String, accountIds::String)
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/stream/accounts"
    url = join(["$api_endpoint/$accountIds/orders"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    while true
        try
            HTTP.open("GET", url, headers=headers) do io
                startread(io)

                while !eof(io)
                    data = String(readavailable(io))

                    try
                        json_dict = JSON3.read(IOBuffer(data))
                        println(json_dict)
                    catch e
                        println("Error processing JSON: $e")
                    end
                end
            end
        catch e
            println("Error during HTTP request: $e")
        end

        println("Connection closed. Reconnecting...")
        sleep(1)  # Add a delay before attempting to reconnect
    end
end


# get orders by id
function stream_orders_by_id(access_token::String, accountIds::String, orderIds::String)
    # API endpoint URL
    api_endpoint = "$trading_api_url/brokerage/stream/accounts"
    url = join(["$api_endpoint/$accountIds/orders/$orderIds"])

    # Define the headers with the Bearer token
    headers = Dict(
        "Authorization" => "Bearer $access_token"
    )

    while true
        try
            HTTP.open("GET", url, headers=headers) do io
                startread(io)

                while !eof(io)
                    data = String(readavailable(io))

                    try
                        json_dict = JSON3.read(IOBuffer(data))
                        println(json_dict)
                    catch e
                        println("Error processing JSON: $e")
                    end
                end
            end
        catch e
            println("Error during HTTP request: $e")
        end

        println("Connection closed. Reconnecting...")
        sleep(1)  # Add a delay before attempting to reconnect
    end
end

# stream positions
function stream_positions(access_token::String, accountIds::String; changes::Bool=false)
    api_endpoint = "$trading_api_url/brokerage/stream/accounts"
    url = join(["$api_endpoint/$accountIds/positions?changes=$changes"])

    headers = Dict("Authorization" => "Bearer $access_token")

    while true
        try
            HTTP.open("GET", url, headers=headers) do io
                startread(io)

                while !eof(io)
                    data = String(readavailable(io))

                    try
                        json_dict = JSON3.read(IOBuffer(data))
                        println(json_dict)
                        #global open_position_qty = json_dict.Quantity
                    catch e
                        println("Error processing JSON: $e")
                    end
                end
            end
        catch e
            println("Error during HTTP request: $e")
        end

        println("Connection closed. Reconnecting...")
        sleep(1)  # Add a delay before attempting to reconnect
    end

end