#MarketData

#Get Bars
function get_bars(access_token::String; interval::String="1", unit::String="Daily", barsback::Any=nothing, firstdate::Any=nothing, lastdate::Any=nothing, sessiontemplate::String="Default")
    if !isnothing(barsback) && (!isnothing(firstdate) || !isnothing(lastdate))
        @assert isnothing(barsback) && isnothing(firstdate) || !isnothing(barsback) && isnothing(firstdate) "can not state both barsback and firstdate - only separately - firstdate is mutually exclusive with barsback"
    end

    # API endpoint URL
    api_endpoint = "https://api.tradestation.com/v3/marketdata/barcharts"

    # Define the path parameter (symbol)
    symbol = "MSFT"

    # Define the query parameters
    query_params = Dict(
        "interval" => interval,  # Default: 1. Interval that each bar will consist of - for minute bars, the number of minutes aggregated in a single bar. For crypto symbols, valid values are: 1, 5, 15, 30, 60, 240, 480. For bar units other than minute, value must be 1. For unit Minute the max allowed Interval is 1440.
        "unit" => unit,  # Default: Daily. The unit of time for each bar interval. Valid values are: Minute, Daily, Weekly, Monthly.
        "barsback" => barsback,  # Default: 1. Number of bars back to fetch (or retrieve). The maximum number of intraday bars back that a user can query is 57,600. There is no limit on daily, weekly, or monthly bars. This parameter is mutually exclusive with firstdate
        "firstdate" => firstdate, # Does not have a default value. The first date formatted as YYYY-MM-DD,2020-04-20T18:00:00Z. This parameter is mutually exclusive with barsback.
        "lastdate" => lastdate, # Defaults to current timestamp. The last date formatted as YYYY-MM-DD,2020-04-20T18:00:00Z. This parameter is mutually exclusive with startdate and should be used instead of that parameter, since startdate is now deprecated.
        "sessiontemplate" => sessiontemplate # States (US) stock market session templates, that extend bars returned to include those outside of the regular trading session. Ignored for non-US equity symbols. Valid values are: USEQPre, USEQPost, USEQPreAndPost, USEQ24Hour,Default
    )


    # Construct the full URL with path and query parameters
    full_url = "$api_endpoint/$symbol?" * join([string(key) * "=" * string(value) for (key, value) in query_params if value !== nothing], "&")

    # or 
    #=
    function construct_barcharts_url(url, params)
        param_list = join(["$key=$value" for (key, value) in params], "&")
        return "$api_endpoint/$symbol?$param_list"
    end


    construct_barcharts_url(api_endpoint,query_params)
    =#

    # Example GET request with the access token included in the Authorization header
    response = HTTP.get(full_url, headers = ["Authorization" => "Bearer $access_token"])

    # parse the HTTP response body
    res = JSON3.read(IOBuffer(response.body))
    bars_data = res["Bars"]

    # Create a DataFrame from the array of dictionaries
    df = DataFrame(bars_data)

    return df

end