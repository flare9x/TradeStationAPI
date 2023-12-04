# TradeStationAPI

A Julia client library for the TradeStation API.

The functions that are available:

## Authorization

manual_authorization_url(), access_token_req(), refresh_token_req(), refresh_token_timer()

## MarketData

get_bars()

## Brokerage

get_accounts(), get_balances(), get_balances_BOD(), get_historical_orders(), get_historical_orders_by_order_id(), get_orders(), get_orders_by_order_id(), get_positions(), get_wallets(), stream_wallets(), stream_orders(), stream_orders_by_id(), stream_positions()

## Orders

place_order(), get_routes(), simple_market_order(), simple_limit_order()

## Authorization 

Step 1 
```julia
using TradeStationAPI
TradeStationAPI.select_account("paper")
TradeStationAPI.manual_authorization_url(client_id, redirect_uri, scopes)
```
This will output a URL where you can enter into a web browser in exchange for a 16 digit Authorization Code

Step 2

authorization_code = 16 digit Authorization Code recieived in Step 1

```julia
TradeStationAPI.access_token_req(client_id, client_secret, authorization_code, redirect_uri)
```

Step 3

Each access token will last for 20 minutes. 

However, a refresh token is long-lived. This means you do not need to continually perform the full sign-in process. A refresh token can be used, as needed, to generate new access tokens.

To generate a new access token 
```julia
TradeStationAPI.refresh_token_req(client_id, client_secret, refresh_token_out)
```

Given each access tokens life span is 20 minutes. Inside a trading application one may call 
```julia
TradeStationAPI.refresh_token_timer(expiry_seconds; offset_seconds, client_id, client_secret, refresh_token_out, stop_date_time=DateTime("2023-12-03T22:15:00"))
```

This function runs recursivley until the stop date/time. Use case may be running in a trading application and stopping at a session end. An example of calling this with @async 

```julia
println("Starting refresh_token_timer()")
task_token_refresh_timer = @async TradeStationAPI.refresh_token_timer(10; offset_seconds=2, client_id, client_secret, refresh_token_out, stop_date_time=stopping_time)

# Make other calls while refresh_token_timer runs
println("While refresh_token_timer() is running make a request for bar data using get_bars()")
get_bars_out = TradeStationAPI.get_bars(access_token_out; symbol="AAPL", interval="1", unit="Daily", barsback="10", firstdate=nothing, lastdate=nothing, sessiontemplate="Default")
println(get_bars_out)
# Do something else
println("After get_bars() when refresh_token_timer() still running do something else")
for i = 1:10
    println("doing something else $i")
    sleep(1)
end

print("End")
```

```julia
Output

Starting refresh_token_timer()
While refresh_token_timer() is running make a request for bar data using get_bars()

10×18 DataFrame
 Row │ High    Low     Open    Close   TimeStamp             TotalVolume  DownTicks  DownVolume  OpenInterest  IsRealtime  IsEndOfHistory  TotalTicks  UnchangedTicks  UnchangedVolume  UpTicks  UpVolume  Epoch          BarStatus 
     │ String  String  String  String  String                String       Int64      Int64       String        Bool        Bool            Int64       Int64           Int64            Int64    Int64     Int64          String    
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 190.38  188.57  190.25  189.69  2023-11-17T21:00:00Z  50941404        258379    29400125  0                  false           false      509887               0                0   251508  21541278  1700254800000  Closed
   2 │ 191.91  189.88  189.89  191.45  2023-11-20T21:00:00Z  46538614        278659    28300453  0                  false           false      553971               0                0   275312  18238161  1700514000000  Closed
   3 │ 191.52  189.74  191.41  190.64  2023-11-21T21:00:00Z  38134485        229633    21544808  0                  false           false      450729               0                0   221096  16589676  1700600400000  Closed
   4 │ 192.93  190.83  191.49  191.31  2023-11-22T21:00:00Z  39630011        233007    17613202  0                  false           false      463417               0                0   230410  22016808  1700686800000  Closed
   5 │ 190.9   189.25  190.87  189.97  2023-11-24T21:00:00Z  24048344        168861    13446145  0                  false           false      335947               0                0   167086  10602198  1700859600000  Closed
   6 │ 190.67  188.9   189.92  189.79  2023-11-27T21:00:00Z  40552609        258657    18985329  0                  false           false      508876               0                0   250219  21567280  1701118800000  Closed
   7 │ 191.08  189.4   189.78  190.4   2023-11-28T21:00:00Z  38415419        232097    16455790  0                  false           false      457974               0                0   225877  21959628  1701205200000  Closed
   8 │ 192.09  188.97  190.9   189.37  2023-11-29T21:00:00Z  43014224        250131    22795072  0                  false           false      493028               0                0   242897  20219151  1701291600000  Closed
   9 │ 190.32  188.19  189.84  189.95  2023-11-30T21:00:00Z  48794366        247382    30585349  0                  false           false      486679               0                0   239297  18209017  1701378000000  Closed
  10 │ 191.56  189.23  190.33  191.24  2023-12-01T21:00:00Z  45704823        260477    23206016  0                  false            true      515409               0                0   254932  22498806  1701464400000  Closed
After get_bars() when refresh_token_timer() still running do something else
doing something else 1
doing something else 2
doing something else 3
doing something else 4
doing something else 5
doing something else 6
doing something else 7
doing something else 8
2 seconds left. Executing refresh token function
doing something else 9
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik56WXpOekExUXpORVJFTXpNMFZHTkVSRVFqSTBSakV4TmpZek56aEdRVFJETmtJd1JVVXpNUSJ9.eyJodHRwOi8vdHJhZGVzdGF0aW9uLmNvbS9pZ25vcmVfZHVhbF9sb2dvbiI6ImZhbHNlIiwiaHR0cDovL3RyYWRlc3RhdGlvbi5jb20vY2xpZW50X3RhZyI6IlFhZThqIiwiaHR0cDovL3RyYWRlc3RhdGlvbi5jb20vdXNlcm5hbWUiOiJhYmFubmVybWFuOXgiLCJodHRwOi8vdHJhZGVzdGF0aW9uLmNvbS9mZGNuX2lkIjoiMTAwNjM4OTAiLCJodHRwOi8vdHJhZGVzdGF0aW9uLmNvbS9vbnl4X2lkIjozODkyNjA2LCJpc3MiOiJodHRwczovL3NpZ25pbi50cmFkZXN0YXRpb24uY29tLyIsInN1YiI6ImF1dGgwfDEwMDYzODkwIiwiYXVkIjpbImh0dHBzOi8vYXBpLnRyYWRlc3RhdGlvbi5jb20iLCJodHRwczovL3RyYWRlc3RhdGlvbi1wcm9kLnRzbG9naW4uYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTcwMTY2NjA0MCwiZXhwIjoxNzAxNjY3MjQwLCJhenAiOiJmU3JjYklDeFJoSlVqdmZweWdtd29vMU5xOHY0aUdtZiIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgTWFya2V0RGF0YSBSZWFkQWNjb3VudCBUcmFkZSBNYXRyaXggQ3J5cHRvIE9wdGlvblNwcmVhZHMgb2ZmbGluZV9hY2Nlc3MifQ.HuttvK2dQO5ZaMCs_3K53fVm7dRoequXT-NUaYI5gVAHDKwQU05e1VSZGgnhn8Dy0rdUJdZnS1HOZlaPrML5qhtyixp9lS4LAWIr--AO9N2eAANepVaZKGw4tmmO1-cGnaKuNM43OvKai31DD_K2npzTFwGFDqyo50eHGj_CF0Y2z6fI77TYF6qgjAthPzfU2G1nzk1JYx0hWa1obZ808XBMbQWj3c02RHeOlMrTHHTNP2y11BblSo9dxAsL2y1GfyDzMemL0Q2HONpHilhjHuxzCCmUlO2aVz2LoUTWFs7z0G61ntx3BcVCMdECfg1aHoT3fMlqw2yM3LjoyTz1ng
doing something else 10
End
```


