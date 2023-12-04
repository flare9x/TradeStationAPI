# Redirect user for authentication/authorization
function manual_authorization_url(client_id::String, redirect_uri::String, scopes::String)

    # Authorization endpoint URL
    authorization_url = "https://signin.tradestation.com/authorize"

    # Construct the request parameters
    params = Dict(
        "response_type" => "code",
        "client_id" => client_id,
        "redirect_uri" => redirect_uri,
        "audience" => "https://api.tradestation.com",
        "state" => "STATE",
        "scope" => scopes
    )

    # Construct the full authorization URL
    auth_request_url = construct_auth_url(authorization_url, params)

    # Redirecting user to the authorization URL
    println("Redirect user to the following URL for authentication/authorization - enter url into browser:")
    println(auth_request_url)
    
end

# Acess token
# authorization_code is the code recieved from the url tradestation login response from step 1 manual_authorization()
function access_token_req(client_id::String, client_secret::String, authorization_code::String, redirect_uri::String)

    # Token endpoint URL
    token_url = "https://signin.tradestation.com/oauth/token"

    # Construct the request body with necessary parameters
    body = Dict(
        "grant_type" => "authorization_code",
        "client_id" => client_id,
        "client_secret" => client_secret,
        "code" => authorization_code,
        "redirect_uri" => redirect_uri
    )

    # Make the POST request to exchange the authorization code for tokens
    response = HTTP.request("POST",token_url, headers = ["Content-Type" => "application/x-www-form-urlencoded"], body = body)

    # parse the response
    res = JSON3.read(IOBuffer(response.body))

    access_token = res["access_token"]
    expires_in_seconds = res["expires_in"]
    refresh_token = res["refresh_token"]

    # return fields 
    return access_token, refresh_token, expires_in_seconds 

end

# Refresh Token
function refresh_token_req(client_id::String, client_secret::String, refresh_token::String)

    # Token endpoint URL
    token_url = "https://signin.tradestation.com/oauth/token"

    # Construct the request body with necessary parameters
    body = Dict(
        "grant_type" => "refresh_token",
        "client_id" => client_id,
        "client_secret" => client_secret,
        "refresh_token" => refresh_token
    )

    # Make the POST request to exchange the authorization code for tokens
    response = HTTP.request("POST",token_url, headers = ["Content-Type" => "application/x-www-form-urlencoded"], body = body)

    # Parse response
    res = JSON3.read(IOBuffer(response.body))

    access_token = res["access_token"]

    return access_token

end

# refresh token timer 
# each access code has an expirary of 20 minutes or 1200 seconds
# this function will count down the seconds to a manually entered expiration duration
# it will recursivley run until a defined stopping time 
# this can called using @async and can shut down at a specified date / time co-inciding with a trading session as eg.
function refresh_token_timer(expiry_seconds::Int64; offset_seconds::Int64=30, client_id::String, client_secret::String, refresh_token_out::String, stop_date_time::Any=DateTime("2023-12-03T22:15:00"))
    out_access_token = ""
    global token_seconds_remaining = expiry_seconds
    print("starrt token", token_seconds_remaining)
    println("Timer started for $expiry_seconds seconds.")
    for i in reverse(expiry_seconds:-1:0)
        #println("$i seconds remaining.")
        if i == (expiry_seconds-offset_seconds)  # refresh token on count down nearing expiry
            println("$offset_seconds seconds left. Executing refresh token function")
            global out_access_token = refresh_token_req(client_id, client_secret, refresh_token_out)
            println(out_access_token)
        end
        sleep(1)  # Sleep for 1 second so that each iteration is a second
        # make available seconds remaining
        token_seconds_remaining -= i
    end
    println("Countdown finished - Restart Timer")
    # Recursivley run until the stopping time
    if now() < stop_date_time
        refresh_token_timer(expiry_seconds; offset_seconds=2, client_id, client_secret, refresh_token_out)
    end
    return out_access_token
end