#/bin/bash
for zone in * ; do
  if [ -d "$zone" ]; then
    cd $zone
    for appliance in * ; do
      if [ -d "$appliance" ]; then
        cd $appliance
        extract_logs_v5a.sh &
        cd ..
      fi
    done
    cd ..
  fi
done
