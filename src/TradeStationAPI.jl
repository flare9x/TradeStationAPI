module TradeStationAPI

using Test
using HTTP
using JSON3
using DataFrames
using Dates


export
    manual_authorization_url, access_token_req, refresh_token_req, refresh_token_timer, construct_auth_url, get_bars,
    get_accounts, get_balances, get_balances_BOD, get_historical_orders, get_historical_orders_by_order_id, 
    get_orders, get_orders_by_order_id, get_positions, get_wallets, stream_wallets, stream_orders, 
    stream_orders_by_id, stream_positions, place_order, get_routes, simple_market_order, simple_limit_order, simple_stop_limit_order,
    select_account, traverse_dict_remove_nothing, construct_auth_url, select_account

    include("authorization.jl")
    include("brokerage.jl")
    include("market_data.jl")
    include("order_execution.jl")
    include("utils.jl")


    TradeStationAPI.select_account("paper")

end