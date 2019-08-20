local server = require "resty.websocket.server"

local wb, err = server:new{
  timeout = 5000,
  max_payload_len = 65535,
}
if not wb then
  ngx.log(ngx.ERR, "Failed to create a new websocket: ", err)
  return ngx.exit(444)
end

wb:set_timeout(10000)

while true do
  local data, typ, err = wb:recv_frame()
  if not data then
    if not string.find(err, "timeout", 1, true) then
      ngx.log(ngx.ERR, "failed to receive a frame: ", err)
      return ngx.exit(444)
    end
  end

  if typ == "close" then
    -- for typ "close", err contains the status code
    local code = err

    -- send a close frame back:
    local bytes, err = wb:send_close(1000, "closed")
    if not bytes then
      ngx.log(ngx.ERR, "failed to send the close frame: ", err)
      return
    end
    
    ngx.log(ngx.INFO, "closing with status code ", code, " and message ", data)
    return
  end

  if typ == "ping" then
    -- send a pong frame back:
    local bytes, err = wb:send_pong(data)
    if not bytes then
      ngx.log(ngx.ERR, "failed to send frame: ", err)
      return
    end
  elseif typ == "pong" then
    -- just discard the incoming pong frame
  else
    ngx.log(ngx.INFO, "received a frame of type ", typ, " and payload ", data)
    local bytes, err = wb:send_text(data)
    if not bytes then
      ngx.log(ngx.ERR, "failed to send a text frame: ", err)
      return ngx.exit(444)
    end
  end
end
