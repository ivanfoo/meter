require 'sinatra'

get '/metrics' do
  lastProxyRequests = 0
  totalProxyRequests = 0
  file = File.new('/var/log/nginx/access.log', "r")
  while (line = file.gets)
    if /\[[\S\s]*\]/ =~ line
      totalProxyRequests += 1
      proxyRequestDate = /\[[\S\s]*\]/.match(line)
      proxyRequestTimestamp = Date.strptime(proxyRequestDate.to_s, "[%d/%b/%Y:%H:%M:%S %Z]").to_time.to_i
      if proxyRequestTimestamp >= Date.today.prev_day.to_time.to_i
        lastProxyRequests += 1
      end
    end
  end
  file.close

  @lastProxyRequests = lastProxyRequests.to_s
  @totalProxyRequests = totalProxyRequests.to_s

  erb :metrics
end
