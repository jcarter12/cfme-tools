
#!/bin/bash
evmserver_to_db.sh&
process_top_output.sh&
process_vmstat_output.sh&
