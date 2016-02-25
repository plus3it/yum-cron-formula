[![Build Status](https://travis-ci.org/plus3it/yum-cron-formula.svg)](https://travis-ci.org/plus3it/yum-cron-formula)`

# linux-yum_cron-formula
This formula is designed to handle the configuration of the yum-cron components for an EL6- or EL7-based instance. When applied, yum-cron will be configured to do daily checks for available RPM updates. If updates are available, yum-cron will:
* Download the updates
* Send a notification to a designated system-owner
It is expected that system-owners will apply all available updates within 45 days of being notified of a new kernel RPM

This formula will pull local hostname information via SaltStack's "grains" functionality using any one of the:
* host
* fqdn
* domain
Values.
