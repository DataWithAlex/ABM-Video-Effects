using Genie

route("/") do
    "Hello from a simple Genie server!"
end

up(host = "0.0.0.0", port = 8000)