##################
# EL6 Parameters
##################
YUM_PARAMETER=
CHECK_ONLY=yes
CHECK_FIRST=yes
DOWNLOAD_ONLY=yes
# ERROR_LEVEL=0
# DEBUG_LEVEL=1
RANDOMWAIT="60"
MAILTO=${ses-recipient}
# SYSTEMNAME="" 
# DAYS_OF_WEEK="0123456"
CLEANDAY="0"
SERVICE_WAITS=yes
SERVICE_WAIT_TIME=300

##################
# EL7 Parameters
##################
update_cmd = default
update_messages = yes
download_updates = yes
apply_updates = no
system_name = None
emit_via = stdio,email
email_from = ${email-from}
email_host = localhost
email_to = ${ses-recipient}
