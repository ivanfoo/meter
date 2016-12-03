require 'sinatra'

get '/' do
  last_nginx_requests = 0
  nginx_get_requests = 0
  nginx_post_requests = 0
  total_nginx_requests = 0
  nginx_log_file = '/var/log/nginx/access.log'

  system_available_memory = 0
  system_total_memory = 0

  # nginx metris
  if ! File.file?(nginx_log_file)
      erb :metrics
  else
    file = File.new(nginx_log_file, "r")

    while (line = file.gets)
      if /\[[\S\s]*\]/ =~ line
        total_nginx_requests += 1
        nginx_request_date = /\[[\S\s]*\]/.match(line)
        nginx_request_timestamp = Date.strptime(nginx_request_date.to_s, "[%d/%b/%Y:%H:%M:%S %Z]").to_time.to_i
        if nginx_request_timestamp >= Date.today.prev_day.to_time.to_i
          last_nginx_requests += 1
        end

        if line.include? "GET"
	  nginx_get_requests += 1
        elsif line.include? "POST"
	  nginx_post_requests += 1
	end

      end
    end
    file.close

    # system metris
    file = File.new("/proc/meminfo", "r")

    while (line = file.gets)
      if line.include? "MemAvailable"
        system_available_memory = /[0-9]+/.match(line).to_s.to_i / 1000
      elsif line.include? "MemTotal"
        system_total_memory = /[0-9]+/.match(line).to_s.to_i / 1000
      end
      if system_available_memory != 0 and system_total_memory != 0
        break
      end
    end
    file.close
    
  end

  @last_nginx_requests = last_nginx_requests
  @nginx_get_requests = nginx_get_requests
  @nginx_post_requests = nginx_post_requests
  @total_nginx_requests = total_nginx_requests

  @system_available_memory = system_available_memory
  @system_total_memory = system_total_memory

  erb :metrics

end

