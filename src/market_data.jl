#MarketData

#Get Bars
function get_bars(access_token::String; symbol::String, interval::String="1", unit::String="Daily", barsback::Any=nothing, firstdate::Any=nothing, lastdate::Any=nothing, sessiontemplate::String="Default")
    if !isnothing(barsback) && !isnothing(firstdate)
        @assert isnothing(barsback) && !isnothing(firstdate) || !isnothing(barsback) && isnothing(firstdate) "can not state both barsback and firstdate - only separately - firstdate is mutually exclusive with barsback"
    end

    # API endpoint URL
    api_endpoint = "$trading_api_url/marketdata/barcharts"

    # Define the query parameters
    query_params = Dict(
        "interval" => interval,
        "unit" => unit, 
        "barsback" => barsback,  
        "firstdate" => firstdate, 
        "lastdate" => lastdate, 
        "sessiontemplate" => sessiontemplate 
    )

    # Construct the full URL with path and query parameters
    full_url = "$api_endpoint/$symbol?" * join([string(key) * "=" * string(value) for (key, value) in query_params if value !== nothing], "&")

    # GET request with the access token included in the Authorization header
    response = HTTP.get(full_url, headers = ["Authorization" => "Bearer $access_token"])

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))
    bars_data = res["Bars"]

    # Create a DataFrame from the array of dictionaries
    df = DataFrame(bars_data)

    return df
end

# Quote snap shots
function get_quote_snapshots(access_token::String, symbols::String)

    # API endpoint URL
    api_endpoint = "$trading_api_url/marketdata/quotes"

    # Construct the full URL with path and query parameters
    full_url = "$api_endpoint/$symbols" 

    # GET request with the access token included in the Authorization header
    response = HTTP.get(full_url, headers = ["Authorization" => "Bearer $access_token"])

    # Parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))

    return res
end


# Stream quotes
function stream_quotes(access_token::String, symbols::String)
    # API endpoint URL
    api_endpoint = "$trading_api_url/marketdata/stream/quotes"

    # Construct the full URL with path and query parameters
    full_url = "$api_endpoint/$symbols"

    # Create headers with the access token
    headers = Dict("Authorization" => "Bearer $access_token")

    while true
        try
            # Open streaming connection
            HTTP.open("GET", full_url, headers=headers) do io
                startread(io)

                # run while eof not true
                while !eof(io)
                    data = String(readavailable(io))

                    try
                        json_dict = JSON3.read(IOBuffer(data))
                        println(json_dict)
                        #global bid_price = json_dict.Bid
                        #global futures_Symbol = json_dict.Symbol
                        #global ask_price = json_dict.Ask
                        #global last_price = json_dict.Last
                    catch e
                        println("Error processing JSON: $e")
                    end
                end
            end
        catch e
            println("Error during HTTP request: $e")
        end

        # While loop exited, error of EOF true - now sleep(1) and try open the stream again
        println("Connection closed. Reconnecting...")
        sleep(1)  # Add a delay before attempting to reconnect
    end
end



