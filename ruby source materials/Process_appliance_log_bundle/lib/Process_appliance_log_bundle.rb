=begin rdoc
Copyright 2008,2009, 20010, 2011 ManageIQ, Inc
$Id: Process_appliance_log_bundle.rb 27760 2011-04-04 18:26:23Z thennessy $
=end

def reset_arrays
$evm.clear
$production.clear
$top_output.clear
$mongrel.clear
$vmstat.clear
$vim.clear
$serverlog.clear
$postgresql.clear
$audit.clear
$automation.clear
$policy.clear
$fog.clear
$aws.clear
$rhevm.clear
$scvmm.clear
$kubernetes.clear
end
def extract_selected_files(bundle,new_directory,selected_files)
#  case $runtime_environment 
#    when /linux/ then 
#        selected_files.tr!('\\','/')   
#        directory_separator = "/"
#  else
#        directory_separator = "\\"
#  end
    selected_files.tr!("\\","/")
    # In sept 2015 the code is being modified to use linux path conventions so the backslash is being convered to slash in pathing generally
    puts "#{__FILE__}:#{__LINE__} - #{selected_files.inspect}"
#    cmd_line = '"c:\\program files\\7-zip\\7z" e ' + bundle + " -o.\\#{new_directory} #{selected_files}"
    cmd_line = 'unzip  -j ' + bundle + "  #{selected_files} -d #{new_directory}"
    puts "#{cmd_line}"
    puts "length of cmd_line is #{cmd_line.size}"
    extract_result = `#{cmd_line}`
    puts "#{__FILE__}:#{__LINE__}- #{cmd_line}\n\t#{extract_result}\n *** end of output \n\n"
end
puts Dir.pwd
File.delete("launch_analysis.cmd") if File.exist?("launch_analysis.cmd")
post_processing = File.new("launch_analysis.cmd","w")
$evm = Array.new
$production = Array.new
$top_output = Array.new
$mongrel = Array.new
$vmstat = Array.new
$vim = Array.new
$serverlog = Array.new
$postgresql = Array.new
$audit = Array.new
$automation = Array.new
$policy = Array.new
$fog = Array.new
$aws = Array.new
$rhevm = Array.new
$scvmm = Array.new
$kubernetes = Array.new

$runtime_environment = "#{RUBY_PLATFORM}"
$directory_separator = ""
case $runtime_environment
when /linux/ then $directory_separator = "/"
else
  $directory_separator = "\\"
  end


process_dir = Dir.pwd
process_files = Dir.glob("*.[Zz][Ii][Pp]")
if process_files.size > 0 then
  puts "#{process_files.inspect}"
else
  puts "for location '#{Dir.pwd}' no *.zip files are identified. processing ending"
  exit
end
process_files.each do |bundle|
#  $production.clear
#  $evm.clear
#  $top_output.clear
#  $mongrel.clear
  puts "#{bundle}"
  _vector = bundle.tr("_.","  ").split
  _appliance_name = _vector[0]
  _appliance_id = _vector[1]
  _appliance_log_collect_date = _vector[-3]
  _appliance_log_collect_time = _vector[-2]
  _vector1 = bundle.split("_")                      #assume patholigical naming for appliance
  if _vector1.size >3 then
    # -1 is time.zip
    # -2 is date
    # -3 is appliance key
    # 0..-4 is the appliance name
    _appliance_id = _vector1[-3]
    _appliance_name = _vector1[0...(_vector1.size - 3)].join("_")
  end

  _bundle_file_type = _vector[-1]
  puts "#{_vector.inspect}"
#  _return = `"c:\\program files\\7-zip\\7z" l #{bundle}`.split("\n")
  _return = `unzip -l  #{bundle}`.split("\n")
  puts "#{_return.inspect}"
_return.each do |line| 
   puts "#{line}"
   next if /ROOT/ =~ line             # code change to exclude CFME postgresql gz files from being processed twice
  _line = line.split
#  if /\.gz/ =~ _line[-1] && /evm|production|top_output|mongrel\.3000|vmstat_output|vim|serverlog/ =~ _line[-1] then
# uncomment out above line if vim.log processing is desired otherwise it is disabled because
# the uncompressed vim.log files are way too large to keep around (tch April 2011)

  if /\.gz/ =~ _line[-1] && 
     /evm|production|top_output|mongrel\.3000|vmstat_output|serverlog|postgresql|audit|automation|policy|fog|aws|rhevm|scvmm|kubernetes/ =~ _line[-1] then
    puts "\tgot one #{_line[-1]}"
    _item_string = _line[-1].tr('.-',"  ").split
    # log\evm.log-yyyymmdd.gz becomes log\evm log yyyymmdd gz
    # log\mongrel.3000.log-yyyymmdd.gz becomes log\mongrel 3000 log yyyymmdd gz
    # log\serverlog-yyyymmdd.gz becomes log\serverlog yyyymmdd gz
    if /mongrel/ =~ _line[-1] then
      if _item_string.size > 4 then
      _target_type = _item_string[-5].split('/')[-1]      # generate word for "split" below
      _target_in_directory = _line[-1].split('/' + _target_type)[0] # do split for directory name
      _target_type  = _target_type + "." + _item_string[-4]              #patch together the mongrel log file info
      end
    else
      if _item_string.size > 3 then
      puts "#{__FILE__}:#{__LINE__}- compressed file name is '#{_item_string[-4]}'"
      _target_type = _item_string[-4].split('/')[-1] 
      _target_in_directory = _line[-1].split('/'+_target_type)[0]
      end
      if _item_string.size == 3 then
      puts "#{__FILE__}:#{__LINE__}- compressed file name is '#{_item_string[-3]}'"
      _target_type = _item_string[-3].split('/')[-1]
      puts "#{__FILE__}:#{__LINE__}- _target_type is '#{_target_type}'"      
      _target_in_directory = _line[-1].split('/'+_target_type)[0]
      end
    end

    _date_value = _item_string[-2].to_i
#    if _target_type == "vmstat_output" then
#      puts "#{__FILE__}:#{__LINE__}"
#    end
    case _target_type
      when "kubernetes" then
        $kubernetes << _date_value
        if _date_value.to_s.size >= 4 then
          $kubernetes_separator = "-"
        else
          $kubernetes_separator = "."
        end    
      when "scvmm" then
        $scvmm << _date_value
        if _date_value.to_s.size >= 4 then
          $scvmm_separator = "-"
        else
          $scvmm_separator = "."
        end
      when "rhevm" then
        $rhevm << _date_value
        if _date_value.to_s.size >= 4 then
          $rhevm_separator = "-"
        else
          $rhevm_separator = "."
        end
      when "aws" then
        $aws << _date_value
        if _date_value.to_s.size >= 4 then
          $aws_separator = "-"
        else
          $aws_separator = "."
        end
      when "fog" then
        $fog << _date_value
        if _date_value.to_s.size >= 4 then
          $fog_separator = "-"
        else
          $fog_separator = "."
        end
      when "policy" then
        $policy << _date_value
        if _date_value.to_s.size >= 4 then
          $policy_separator = "-"
        else
          $policy_separator = "."
        end
      when "automation" then
        $automation << _date_value
        if _date_value.to_s.size >= 4 then
          $automation_separator = "-"
        else
          $automation_separator = "."
        end
      when "audit" then
        $audit << _date_value
        if _date_value.to_s.size >= 4 then
          $audit_separator = "-"
        else
          $audit_separator = "."
        end
    when "evm" then 
      $evm << _date_value
      if _date_value.to_s.size >= 4 then
        $evm_separator = "-"
      else
        $evm_separator = "."
      end
    when "production" then $production << _date_value
      if _date_value.to_s.size >= 4 then
        $production_separator = "-"
      else
        $production_separator = "."
      end
    when "top_output" then $top_output << _date_value      
      if _date_value.to_s.size >= 4 then
        $top_output_separator = "-"
      else
        $top_output_separator = "."
      end
    when "vmstat_output" then $vmstat << _date_value
      if _date_value.to_s.size >= 4 then
        $vmstat_separator = "-"
      else
        $vmstat_separator = "."
      end
    when "postgresql" then $postgresql << _date_value
      if _date_value.to_s.size >= 4 then
        $postgresql_separator = "-"
      else
        $postgresql_separator = "."
      end  
    when /serverlog/ then $serverlog << _date_value
      if _date_value.to_s.size >= 4 then
        $serverlog_separator = "-"
      else
        $serverlog_separator = "."
      end
    when /vim/ then $vim << _date_value
      if _date_value.to_s.size >= 4 then
        $vim_separator = "-"
      else
        $vim_separator = "."
      end
    when /mongrel/ then
      $mongrel << _date_value if /\.pid/ !~ _line[-1]     # don't capture the ".pid" file
      if _date_value.to_s.size >= 4 then
        $mongrel_separator = "-"
      else
        $mongrel_separator = "."
      end
    end

  end
  
 
end
_temp_array =[$evm,$production,$top_output,$mongrel,$vmstat,$vim,$postgresql,$serverlog,$audit,$automation,$policy,$fog,$aws,$rhevm,$scvmm,$kubernetes]
_temp_array.each do |x|
if x.size > 0 then x.sort! end
# stardard sort is ascending order which is fine if yyyymmdd is what is being sorted (oldest to newest)
# but if logrotate is using integers then we want to go from largest (oldest) to smallest( newest)
# so I'll check the separator length of the first array element to see if I need to reverse the array elements.
#   =8  means yyyymmdd is used and the order is OK
#   <8 means that a logrotate integer is used so the order needs to be reversed
if x[0].to_s.size < 8 then
  x.reverse!
end
  end

#if
    puts "evm file count is #{$evm.size}\nproduction file count is #{$production.size}\ntop_output file count is #{$top_output.size}" + 
      "\nmongrel file count is #{$mongrel.size}\nvmstat file count is #{$vmstat.size}" +
      "\nvim file count is #{$vim.size}\nserverlog file count is #{$serverlog}\npostgresql.log file count is #{$postgresql.size}" + 
      "\naudit file count is #{$audit.size} " +
       "\nautomation file count is #{$automation.size}" +
       "\npolicy file count is #{$policy.size}" +
       "\nfog file count is #{$fog.size}" +
       "\naws file count is #{$aws.size}" +
       "\nrhevm file count is #{$rhevm.size}" +
       "\nscvmm file count is #{$scvmm.size}" +
       "\nkubernetes file count is #{$kubernetes.size}"         
#     puts "#{__FILE__}:#{__LINE__}"
##     # create a new directory for each of the appliance names
     new_directory = _appliance_name + "_" + _appliance_id + "_" +  _appliance_log_collect_date + "_" + _appliance_log_collect_time + "_analyzd"
     if File.directory?(new_directory ) then              # if this directory already exists, then stop processing this zip file
       puts "directory '#{new_directory}' already exists! processing is moving to next zip file\n\n"
       reset_arrays()
       next
     else
       Dir.mkdir(new_directory)
       puts "directory '#{new_directory}' has been created"
     end
     # now for each of the evm files for each directory copy the evm.log-"date" files 
     # from oldest to newest into the associated directory
     # using 7-Zip command
     selected_files = ""
     ["evm","production","top_output","mongrel.3000","vmstat_output","vim","postgresql","serverlog","audit","automation","policy","fog","aws","rhevm","scvmm","kubernetes"].each do |type|
         case type
         when "mongrel.3000" then 
           $mongrel.each do |_x|
             selected_files << "log\\" + type + ".log" + $mongrel_separator + _x.to_s  + ".gz "
            end
            selected_files = selected_files + "log\\mongrel.3000.log "
           extract_selected_files(bundle,new_directory,selected_files)
            selected_files = ""
#           selected_files << "log\\mongrel.3000.log"
           # capture the mongrel cluster startup file to examine for startup problems
         when "evm"
           $evm.each do |_x|
             selected_files << "log\\evm.log" + $evm_separator + _x.to_s + ".gz "
            end
            selected_files = selected_files + "log\\evm.log log\\last_startup.txt log\\VERSION log\\BUILD log\\GUID"
           extract_selected_files(bundle,new_directory,selected_files)
#           if File.exist?(new_directory+"\\last_startup.txt") then
#              puts "launching last_statup analysis using #{new_directory} as target directory"
#              _cmd = "cmd start /d #{Dir.pwd}/#{new_directory} process_last_startup_txt_file.cmd 1>last_startup_stdout.txt 2>last_startup_stderr.txt"
#              puts "launced cmd is '#{_cmd}'"
#              pipe = IO.popen(_cmd)
##             _cmd_return = `#{_cmd} `
##              puts "result from launced md is #{_cmd_return}"
#           end
            selected_files = ""
         when "production" then
            $production.each do |_x|
               selected_files <<  "log\\production.log" + $production_separator + _x.to_s + ".gz "
             end
             selected_files << " log\\production.log "
           extract_selected_files(bundle,new_directory,selected_files)
            selected_files = ""
         when "vim" then
             $vim.each do |_x|
               selected_files <<  "log\\vim.log" + $vim_separator + _x.to_s + ".gz "
             end
             selected_files << " log\\vim.log "
           extract_selected_files(bundle,new_directory,selected_files)
            selected_files = ""
         when "serverlog" then
            $serverlog.each do |_x|
               selected_files <<  "log\\serverlog" + $serverlog_separator + _x.to_s + ".gz "
             end
             selected_files << " log\\serverlog "
           extract_selected_files(bundle,new_directory,selected_files)
            selected_files = "" 
            
         when "postgresql"
            $postgresql.each do |_x|
               selected_files << "log\\postgresql.log" + $postgresql_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\postgresql.log "
           extract_selected_files(bundle,new_directory,selected_files)
            selected_files = ""          
         when "top_output"
            $top_output.each do |_x|
               selected_files << "log\\top_output.log" + $top_output_separator + _x.to_s  + ".gz "
             end
             selected_files << "log\\top_output.log "
           extract_selected_files(bundle,new_directory,selected_files)
            selected_files = ""
         when "vmstat_output"
            $vmstat.each do |_x|
               selected_files << "log\\vmstat_output.log" + $vmstat_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\vmstat_output.log "
           extract_selected_files(bundle,new_directory,selected_files)
            selected_files = ""
           when "audit"
             $audit.each do |_x|
               selected_files << "log\\audit.log" + $audit_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\audit.log "
             extract_selected_files(bundle,new_directory,selected_files)
             selected_files = ""
           when "automation"
             $automation.each do |_x|
               selected_files << "log\\automation.log" + $automation_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\automation.log "
             extract_selected_files(bundle,new_directory,selected_files)
             selected_files = ""
           when "policy"
             $policy.each do |_x|
               selected_files << "log\\policy.log" + $policy_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\policy.log "
             extract_selected_files(bundle,new_directory,selected_files)
             selected_files = ""
           when "fog"
             $fog.each do |_x|
               selected_files << "log\\fog.log" + $fog_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\fog.log "
             extract_selected_files(bundle,new_directory,selected_files)
             selected_files = ""
           when "aws"
             $aws.each do |_x|
               selected_files << "log\\aws.log" + $aws_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\aws.log "
             extract_selected_files(bundle,new_directory,selected_files)
             selected_files = ""
           when "rhevm"
             $rhevm.each do |_x|
               selected_files << "log\\rhevm.log" + $rhevm_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\rhevm.log "
             extract_selected_files(bundle,new_directory,selected_files)
             selected_files = ""
           when "scvmm"
             $scvmm.each do |_x|
               selected_files << "log\\scvmm.log" + $scvmm_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\scvmm.log "
             extract_selected_files(bundle,new_directory,selected_files)
             selected_files = ""
           when "kubernetes"
             $kubernetes.each do |_x|
               selected_files << "log\\kubernetes.log" + $kubernetes_separator + _x.to_s + ".gz "
             end
             selected_files << "log\\kubernetes.log "
             extract_selected_files(bundle,new_directory,selected_files)
             selected_files = ""             
         end
         end
#     def extract_selected_files(bundle,new_directory,selected_files)
#          puts "#{__FILE__}:#{__LINE__} - #{selected_files.inspect}"
#          cmd_line = '"c:\\program files\\7-zip\\7z" e ' + bundle + " -o.\\#{new_directory} #{selected_files}"
#          puts "length of cmd_line is #{cmd_line.size}"
#          extract_result = `#{cmd_line}`
#          puts "#{__FILE__}:#{__LINE__}- #{cmd_line}\n\t#{extract_result}\n *** end of output \n\n"
#     end
          save_cwd = Dir.pwd
          Dir.chdir(new_directory)                         #change current directory to new directory
          puts "\n* * * * * * \n\tcwd changed to #{new_directory}\n * * * * * * \n"
          ungzip_results = `gzip -d *.gz`                  #unzip all of the log rotate log files
          puts "gzipd -d results=>'#{ungzip_results.inspect}'"
#     end
          ["evm","production","top_output","mongrel.3000","vmstat","vim","serverlog","postgresql","audit","automation","policy","fog","aws","rhevm","scvmm","kubernetes"].each do |_y|
          case _y
            when "audit" then
              if $audit.size > 0 then
                rename_audit = File.rename("audit.log","audit_output_last.log")
                puts "#{__FILE__}:#{__LINE__}- audit_output rename results=> '#{rename_audit}'"
                $audit.each do |_y1|
                  cmd_line = "cat audit.log" + $audit_separator + "#{_y1} >> audit.log"
                  puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                  copy_file = `#{cmd_line}`
                  File.delete("audit.log" + $audit_separator + _y1.to_s)
                  puts "audit.log#{$audit_separator}#{_y1} file deleted from #{new_directory} after copy"
                end
                copy_last = `cat audit_output_last.log >> audit.log`
                File.delete("audit_output_last.log") if File.exist?("audit_output_last.log")
              else
                # do nothing if there are no log rotate gz files
              end
            when "automation" then
              if $automation.size > 0 then
                rename_automation = File.rename("automation.log","automation_output_last.log")
                puts "#{__FILE__}:#{__LINE__}- automation_output rename results=> '#{rename_automation}'"
                $automation.each do |_y1|
                  cmd_line = "cat automation.log" + $automation_separator + "#{_y1} >> automation.log"
                  puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                  copy_file = `#{cmd_line}`
                  File.delete("automation.log" + $automation_separator + _y1.to_s)
                  puts "automation.log#{$automation_separator}#{_y1} file deleted from #{new_directory} after copy"
                end
                copy_last = `cat automation_output_last.log >> automation.log`
                File.delete("automation_output_last.log") if File.exist?("automation_output_last.log")
              else
                # do nothing if there are no log rotate gz files
              end
            when "policy" then
              if $policy.size > 0 then
                rename_policy = File.rename("policy.log","policy_output_last.log")
                puts "#{__FILE__}:#{__LINE__}- policy_output rename results=> '#{rename_policy}'"
                $policy.each do |_y1|
                  cmd_line = "cat policy.log" + $policy_separator + "#{_y1} >> policy.log"
                  puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                  copy_file = `#{cmd_line}`
                  File.delete("policy.log" + $policy_separator + _y1.to_s)
                  puts "policy.log#{$policy_separator}#{_y1} file deleted from #{new_directory} after copy"
                end
                copy_last = `cat policy_output_last.log >> policy.log`
                File.delete("policy_output_last.log") if File.exist?("policy_output_last.log")
              else
                # do nothing if there are no log rotate gz files
              end
            when "fog" then
              if $fog.size > 0 then
                rename_fog = File.rename("fog.log","fog_output_last.log")
                puts "#{__FILE__}:#{__LINE__}- fog_output rename results=> '#{rename_fog}'"
                $fog.each do |_y1|
                  cmd_line = "cat fog.log" + $fog_separator + "#{_y1} >> fog.log"
                  puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                  copy_file = `#{cmd_line}`
                  File.delete("fog.log" + $fog_separator + _y1.to_s)
                  puts "fog.log#{$fog_separator}#{_y1} file deleted from #{new_directory} after copy"
                end
                copy_last = `cat fog_output_last.log >> fog.log`
                File.delete("fog_output_last.log") if File.exist?("fog_output_last.log")
              else
                # do nothing if there are no log rotate gz files
              end
            when "aws" then
              if $aws.size > 0 then
                rename_aws = File.rename("aws.log","aws_output_last.log")
                puts "#{__FILE__}:#{__LINE__}- aws_output rename results=> '#{rename_aws}'"
                $aws.each do |_y1|
                  cmd_line = "cat aws.log" + $aws_separator + "#{_y1} >> aws.log"
                  puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                  copy_file = `#{cmd_line}`
                  File.delete("aws.log" + $aws_separator + _y1.to_s)
                  puts "aws.log#{$aws_separator}#{_y1} file deleted from #{new_directory} after copy"
                end
                copy_last = `cat aws_output_last.log >> aws.log`
                File.delete("aws_output_last.log") if File.exist?("aws_output_last.log")
              else
                # do nothing if there are no log rotate gz files
              end
            when "rhevm" then
              if $rhevm.size > 0 then
                rename_rhevm = File.rename("rhevm.log","rhevm_output_last.log")
                puts "#{__FILE__}:#{__LINE__}- rhevm_output rename results=> '#{rename_rhevm}'"
                $rhevm.each do |_y1|
                  cmd_line = "cat rhevm.log" + $rhevm_separator + "#{_y1} >> rhevm.log"
                  puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                  copy_file = `#{cmd_line}`
                  File.delete("rhevm.log" + $rhevm_separator + _y1.to_s)
                  puts "rhevm.log#{$rhevm_separator}#{_y1} file deleted from #{new_directory} after copy"
                end
                copy_last = `cat rhevm_output_last.log >> rhevm.log`
                File.delete("rhevm_output_last.log") if File.exist?("rhevm_output_last.log")
              else
                # do nothing if there are no log rotate gz files
              end
            when "scvmm" then
              if $scvmm.size > 0 then
                rename_scvmm = File.rename("scvmm.log","scvmm_output_last.log")
                puts "#{__FILE__}:#{__LINE__}- scvmm_output rename results=> '#{rename_scvmm}'"
                $scvmm.each do |_y1|
                  cmd_line = "cat scvmm.log" + $scvmm_separator + "#{_y1} >> scvmm.log"
                  puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                  copy_file = `#{cmd_line}`
                  File.delete("scvmm.log" + $scvmm_separator + _y1.to_s)
                  puts "scvmm.log#{$scvmm_separator}#{_y1} file deleted from #{new_directory} after copy"
                end
                copy_last = `cat scvmm_output_last.log >> scvmm.log`
                File.delete("scvmm_output_last.log") if File.exist?("scvmm_output_last.log")
              else
                # do nothing if there are no log rotate gz files
              end  
            when "kubernetes" then
              if $kubernetes.size > 0 then
                rename_kubernetes = File.rename("kubernetes.log","kubernetes_output_last.log")
                puts "#{__FILE__}:#{__LINE__}- kubernetes_output rename results=> '#{rename_kubernetes}'"
                $kubernetes.each do |_y1|
                  cmd_line = "cat kubernetes.log" + $kubernetes_separator + "#{_y1} >> kubernetes.log"
                  puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                  copy_file = `#{cmd_line}`
                  File.delete("kubernetes.log" + $kubernetes_separator + _y1.to_s)
                  puts "kubernetes.log#{$kubernetes_separator}#{_y1} file deleted from #{new_directory} after copy"
                end
                copy_last = `cat kubernetes_output_last.log >> kubernetes.log`
                File.delete("kubernetes_output_last.log") if File.exist?("kubernetes_output_last.log")
              else
                # do nothing if there are no log rotate gz files
              end                            
              when "vmstat" then
                if $vmstat.size > 0 then
                  rename_vmstat = File.rename("vmstat_output.log","vmstat_output_last.log")
                  puts "#{__FILE__}:#{__LINE__}- vmstat_output rename results=> '#{rename_vmstat}'"
                  $vmstat.each do |_y1|
                                cmd_line = "cat vmstat_output.log" + $vmstat_separator + "#{_y1} >> vmstat_output.log"
                                puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                                copy_file = `#{cmd_line}`
                                File.delete("vmstat_output.log" + $vmstat_separator + _y1.to_s)
                                puts "vmstat_output.log#{$vmstat_separator}#{_y1} file deleted from #{new_directory} after copy"
                              end
                  copy_last = `cat vmstat_output_last.log >> vmstat_output.log`
                  File.delete("vmstat_output_last.log") if File.exist?("vmstat_output_last.log")
                else
                  # do nothing if there are no log rotate gz files
                end
              when "evm" then
                if $evm.size > 0 then
                  rename_evm = File.rename("evm.log","evm_last.log")
                  puts "#{__FILE__}:#{__LINE__}- evm rename results=> '#{rename_evm}'"
                  $evm.each do |_y1|
                                cmd_line = "cat evm.log" + $evm_separator + "#{_y1} >> evm.log"
                                puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                                copy_file = `#{cmd_line}`
                                File.delete("evm.log" + $evm_separator + _y1.to_s)
                                puts "evm.log#{$evm_separator}#{_y1} file deleted from #{new_directory} after copy"
                              end
                  copy_last = `cat evm_last.log >> evm.log`
                  File.delete("evm_last.log") if File.exist?("evm_last.log")
                else
                  # do nothing if there are no log rotate gz files
                end
                
              when "postgresql" then
                if $postgresql.size > 0 then
                  rename_postgresql = File.rename("postgresql.log","postgresql_last.log")
                  puts "#{__FILE__}:#{__LINE__}- postgresql rename results=> '#{rename_postgresql}'"
#                  prevent_duplicate_delete = ""
                  $postgresql.each do |_y1|
#                                next if prevent_duplicate_delete = _y1
#                                prevent_duplicate_delete = _y1
                                cmd_line = "cat postgresql.log" + $postgresql_separator + "#{_y1} >> serverlog"
                                puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                                copy_file = `#{cmd_line}`
                                File.delete("postgresql.log" + $postgresql_separator + _y1.to_s)
                                puts "postgresql.log#{$postgresql_separator}#{_y1} file deleted from #{new_directory} after copy"
                              end
                  copy_last = `cat postgresql_last.log >> serverlog`
                  File.delete("postgresql_last.log") if File.exist?("postgresql_last.log")
                else
                  # do nothing if there are no log rotate gz files
                end                
                
              when "production" then
                if $production.size > 0 then
                   rename_production = File.rename("production.log","production_last.log")
                  puts "#{__FILE__}:#{__LINE__}- production rename results #{rename_production}"
                  $production.each do |_y1|
                                      cmd_line = "cat production.log" + $production_separator + "#{_y1} >> production.log"
                                      puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                                      copy_file = `#{cmd_line}`
                                      File.delete("production.log" + $production_separator + _y1.to_s)
                                      puts "production.log#{$production_separator}#{_y1} file deleted from #{new_directory} after copy"
                                    end
                  copy_last = `cat production_last.log >> production.log`
                  File.delete("production_last.log") if File.exist?("production_last.log")
                else
                  # do nothing if there are no log rotate gz files
                end
              when "vim" then
                if $vim.size > 0 then
                   rename_vim = File.rename("vim.log","vim_last.log")
                  puts "#{__FILE__}:#{__LINE__}- vim rename results #{rename_vim}"
                  $vim.each do |_y1|
                                      cmd_line = "cat vim.log" + $vim_separator + "#{_y1} >> vim.log"
                                      puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                                      copy_file = `#{cmd_line}`
                                      File.delete("vim.log" + $vim_separator + _y1.to_s)
                                      puts "vim.log#{$vim_separator}#{_y1} file deleted from #{new_directory} after copy"
                                    end
                  copy_last = `cat vim_last.log >> vim.log`
                  File.delete("vim_last.log") if File.exist?("vim_last.log")
                else
                  # do nothing if there are no log rotate gz files
                end

              when "serverlog" then
                if $serverlog.size > 0 then
                   rename_serverlog = File.rename("serverlog","serverlog_last.log")
                  puts "#{__FILE__}:#{__LINE__}- serverlog rename results #{rename_serverlog}"
                  $serverlog.each do |_y1|
                                      cmd_line = "cat serverlog" + $serverlog_separator + "#{_y1} >> serverlog"
                                      puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                                      copy_file = `#{cmd_line}`
                                      File.delete("serverlog" + $serverlog_separator + _y1.to_s)
                                      puts "serverlog#{$serverlog_separator}#{_y1} file deleted from #{new_directory} after copy"
                                    end
                  copy_last = `cat serverlog_last.log >> serverlog`
                  File.delete("serverlog_last.log") if File.exist?("serverlog_last.log")
                else
                  # do nothing if there are no log rotate gz files
                end

              when "top_output" then
                if $top_output.size > 0 then
                   rename_top_output = File.rename("top_output.log","top_output_last.log")
                  puts "#{__FILE__}:#{__LINE__}- top_output rename results #{rename_top_output}"
                  $top_output.each do |_y1|
                                      cmd_line = "cat top_output.log" + $top_output_separator  + "#{_y1} >> top_output.log"
                                      puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                                      copy_file = `#{cmd_line}`
                                      File.delete("top_output.log" + $top_output_separator + _y1.to_s)
                                      puts "top_output.log#{$top_output_separator}#{_y1} file deleted from #{new_directory} after copy"
                                    end
                  copy_last = `cat top_output_last.log >> top_output.log`
                  File.delete("top_output_last.log") if File.exist?("top_output_last.log")
                else
                  # do nothing if there are no log rotate gz files
                end
              when "mongrel.3000" then
                if $mongrel.size > 0 then
                   rename_ = File.rename("mongrel.3000.log","mongrel.3000_last.log")
                  puts "#{__FILE__}:#{__LINE__}- mongrel.3000 rename results #{rename_}"
                  $mongrel.each do |_y1|
                                  cmd_line = "cat mongrel.3000.log" + $mongrel_separator + "#{_y1} >> mongrel.3000.log"
                                  puts "#{__FILE__}:#{__LINE__}- about to execute \n\t'#{cmd_line}'"
                                  copy_file = `#{cmd_line}`
                                  File.delete("mongrel.3000.log" + $mongrel_separator + _y1.to_s)
                                  puts "mongrel.3000.log#{$mongrel_separator}#{_y1} file deleted from #{new_directory} after copy"
                                end
                  copy_last = `cat mongrel.3000_last.log >> mongrel.3000.log`
                  File.delete("mongrel.3000_last.log") if File.exist?("mongrel.3000_last.log")
                  cmd_distill = 'grep -v "to_a" mongrel.3000.log > distilled_mongrel.log '
                  puts "about to distill mongrel.3000.log using '#{cmd_distill}'"
                  distill_mongrel_log = `#{cmd_distill} `
                  puts " results from distilling mongel.3000.log to distilled_mongrel.log\n\t'#{distill_mongrel_log}'"
                else
                  # do nothing if there are no log rotate gz files
                end
          end
            end

            #start procesing for this directory
#            cmd_line = "call start /d #{new_directory} process_last_startup_txt_file "
#            post_processing.puts cmd_line
#            puts " created cmd to analyze last_startup.txt"
            # process last_startup.txt if it is there
            cmd_line = "call start /d #{new_directory} /BELOWNORMAL evmserver_to_db ."
            post_processing.puts cmd_line
            puts "created cmd for  evm log analysis "
#            `#{cmd_line}`
#            `call start process_top_output .`
            post_processing.puts "call start /d #{new_directory} process_top_output ."
            puts "created cmd for  top analysis prepended with cmd to process_last_startup_txt_file"
            post_processing.puts "call start /d #{new_directory} process_vmstat_output ."
            puts "created cmd for vmstat analysis"
          Dir.chdir("..")                                  #restore previous current working directory
          puts "working directory after return from gzip call is now #{Dir.pwd}"
          if save_cwd != Dir.pwd then
            puts "#{__FILE__}:#{__LINE__}- \n\tcurrent working directory #{Dir.pwd} not the expected working directory #{save_cwd}\n\tprocessing terminating:"
            exit
          end
          reset_arrays()
  end
  post_processing.puts "exit"
  post_processing.close
#  `launch_analysis.cmd`

     
#reset_arrays()
#
#    puts "#{__FILE__}:#{__LINE__}"
#end
