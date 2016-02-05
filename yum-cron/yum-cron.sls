#
# Salt formula to install and configure the yum-cron facility 
# onto EL6- and EL7-based systems
#
#################################################################

pkg_yum-cron:
  pkg.installed:
    - name: yum-cron
    - allow_updates: True
