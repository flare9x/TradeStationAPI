# Function to construct the authorization URL
function construct_auth_url(url, params)
    param_list = join(["$key=$value" for (key, value) in params], "&")
    return "$url?$param_list"
end

# Function to define the sim or live trading account
function select_account(select_account::String)
    if select_account != "paper" || select_account != "live"
        @assert select_account == "paper" || select_account == "live" "select_account available arguments :: 'paper' or 'live'"
    end

    # set the URL for paper or live trading
    if select_account == "paper"
        global trading_api_url = "https://sim-api.tradestation.com/v3"
    elseif select_account == "live"
        global trading_api_url = "https://api.tradestation.com/v3"
    end
end

# Recursive function to traverse the Dict and filter out key-value pairs where 'value' == nothing
# return filtered Dict
function traverse_dict_remove_nothing(::Dict)
    new_dict = Dict()
    for (key, value) in dict
        # check if value is a Dict
        if value isa Dict
            # call function to handle nested Dicts
            new_value = traverse_dict_remove_nothing(value)
            # if its not empty it has non-nothing values, add this key value pair to new_dict
            if !isempty(new_value)
                new_dict[key] = new_value
            end
            # if not nothing add key value pair to new_dict
        elseif !isnothing(value)
            new_dict[key] = value
        end
    end
    return new_dict
end