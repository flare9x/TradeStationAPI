# Function to construct the authorization URL
function construct_auth_url(url, params)
    param_list = join(["$key=$value" for (key, value) in params], "&")
    return "$url?$param_list"
end