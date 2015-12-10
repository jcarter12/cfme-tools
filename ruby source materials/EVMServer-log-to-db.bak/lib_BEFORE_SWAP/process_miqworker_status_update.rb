=begin rdoc
Copyright 2008 ManageIQ, Inc
$Id: process_miqworker_status_update.rb 16597 2009-10-12 15:36:47Z thennessy $
=end
def process_miqworker_status_update(_payload)  # one explicit input parm: parsed miq payload and
                                                 # one implicit :$Parsed_log_line
#[----] I, [2009-01-07T12:51:21.235250 #4738]  INFO -- : MIQ(MiqWorkerMonitor) [EVM Worker Monitor (4696)] Worker guid [1873fc70-dcb9-11dd-8167-0050569b236d],
#Last Heartbeat [Wed Jan 07 12:50:24 UTC 2009],
#Process Info: Memory Usage [72744960], Memory Size [89018368], Memory % [1.8], CPU Time [00:00:09], CPU % [2.6], Priority [30]

# Altered 20090110
#[----] I, [2009-01-10T14:25:59.770255 #4881]  INFO -- : MIQ(MiqWorker-status_update) MiqPriorityWorker:
# [Priority Queue (4869)] Worker guid [d8bd22e4-df21-11dd-8ba9-0050569b77f6], Last Heartbeat [Sat Jan 10 14:25:57 UTC 2009],
# Process Info: Memory Usage [72028160], Memory Size [79831040], Memory % [1.8], CPU Time [00:00:07], CPU % [2.4], Priority [30]

#MIQ(MiqServer-status_update) [EVM Server (4500)] Process info: Memory Usage [113168384], Memory Size [128307200], Memory % [2.79999995231628],
# CPU Time [07:43:48], CPU % [6.59999990463257], Priority [30] 
        if /EVM Server/ =~ _payload.miq_post_cmd then
          puts "#{__FILE__}:#{__LINE__} -> #{_payload.inspect}"
        end
#      if /(.*)\:\s*\[(.*)\((\d{1,5})\)\]\s*(.*)Process Info:\s*(.*)/ =~ _payload.miq_post_cmd  then  
       if $La_63 =~ _payload.miq_post_cmd then
        _worker_method_name = $1
        _worker_type_text = $2
        _worker_pid = $3
        _worker_part1 = $4
        _worker_part2 = $5
        _worker_stats_hash = Hash.new
          _worker_stats_hash["category"] = nil
          _worker_stats_hash["subcategory"] = nil
          _worker_stats_hash["ip_address"] = nil
          _worker_stats_hash["priority"] = nil
          _worker_stats_hash["worker_type"] = nil
#        if /Event Monitor/ =~ _worker_type_text then                #log doesn't differentiate well between
          if $La_64 =~ _worker_type_text then
          _worker_stats_hash["worker_type"] = _worker_method_name   # event catcher and handler, so take the type from the method name
          _worker_type_text.split.each do |_worker_type_word|
              case _worker_type_word
#              when /vCenter\:/ then _worker_stats_hash["category"] = "Virtual Center"    # capture vCenter as the category
              when $La_65  then _worker_stats_hash["category"] = "Virtual Center"    # capture vCenter as the category
#              when /\((.*)\)/ then _worker_stats_hash["ip_address"] = $1                  # Capture the ip address of the EMS
              when $La_66 then _worker_stats_hash["ip_address"] = $1                  # Capture the ip address of the EMS
              end
          end
        else                                                        # from the method name
          _worker_stats_hash["worker_type"] = _worker_type_text
        end
          _worker_stats_hash["worker_pid"] = _worker_pid

#          if /[Ee]vent/ =~ _payload.miq_cmd then            # if event is part of the miq cmd
          if $La_67 =~ _payload.miq_cmd then            # if event is part of the miq cmd
                                                            # then is is either a monitor or a handler - catch it
                                                            # and isolate the ip address being monitored too
          _worker_type_text_array = _worker_type_text.split # break into separate words and replace last with event type
          case _payload.miq_cmd
#          when /[Cc]atcher/ then _worker_type_text_array[-1] = "Catcher"
#          when /[Hh]andler/ then _worker_type_text_array[-1] = "Handler"
          when $La_68 then _worker_type_text_array[-1] = "Catcher"
          when $La_69 then _worker_type_text_array[-1] = "Handler"

          end
          _worker_type_text = _worker_type_text_array.join(" ")  # recombine phrase
          _worker_stats_hash["worker_type"] = _worker_type_text  # update the worker type to be catcher or handler type
          _worker_type_text_array.each do |_word|
                case _word
#                when /\((.*)\)/ then _worker_stats_hash["ip_address"] = $1
                when $La_66 then _worker_stats_hash["ip_address"] = $1
#                when /vCenter\:/ then _worker_stats_hash["category"] = "Virtual Center"
                when $La_65 then _worker_stats_hash["category"] = "Virtual Center"
                end
              end
          end
          capture_process_info(_worker_part1,_worker_part2,_worker_stats_hash,$Parsed_log_line.log_datetime)
      end
end