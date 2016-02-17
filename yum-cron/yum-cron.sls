#
# Salt formula to install and configure the yum-cron facility 
# onto EL6- and EL7-based systems
#
#################################################################

# Need PostFix with cyrus-sasl-plain to act as a SASL-authenticated client
pkg_support:
  pkg.installed:
    - pkgs:
      - postfix
      - cyrus-sasl-plain

# Need this to automate runing of cron update-availability detection
pkg_yum-cron:
  pkg.installed:
    - name: yum-cron
    - allow_updates: True
