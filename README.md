# TradeStationAPI

A Julia client library for the TradeStation API.

The functions that are available:

## Authorization

manual_authorization_url(), access_token_req(), refresh_token_req(), refresh_token_timer()

## MarketData

get_bars()

## Brokerage

get_accounts(), get_balances(), get_balances_BOD(), get_historical_orders(), get_historical_orders_by_order_id(), get_orders(), get_orders_by_order_id(), get_positions(), get_wallets(), stream_wallets(), stream_orders(), stream_orders_by_id(), stream_positions()