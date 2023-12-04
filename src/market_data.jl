#MarketData

#Get Bars
function get_bars(access_token::String, symbol::String; interval::String="1", unit::String="Daily", barsback::Any=nothing, firstdate::Any=nothing, lastdate::Any=nothing, sessiontemplate::String="Default")
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