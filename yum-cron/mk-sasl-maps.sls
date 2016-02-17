#
# Grab data out of Pillar and Grains to construct the SASL
# client files
#
#################################################################
{%- set smtp_host = salt['grains.get']('host') %}
{%- set smtp_domain = salt['grains.get']('domain') %}
{%- set smtp_fqdn = salt['grains.get']('fqdn') %}
{%- set notice_sender = salt['pillar.get']('yum-cron:smtp:addr-sender', None) %}
{%- set notice_recipt = salt['pillar.get']('yum-cron:smtp:addr-recipient', None) %}
{%- set sasl_user = salt['pillar.get']('yum-cron:smtp:sasl-user', None) %}
{%- set sasl_passwd = salt['pillar.get']('yum-cron:smtp:sasl-passwd', None) %}
{%- set smtp_relay = salt['pillar.get']('yum-cron:smtp:smart-relay', None) %}
{%- set smtp_port = salt['pillar.get']('yum-cron:smtp:smart-relay-port', 25) %}


# Add {{ notice_sender }} to SASL password-map
file-sasl_passwd:
  file.append:
    - name: /etc/postfix/sasl_passwd
    - text: |
        {{ notice_sender }}@{{ smtp_fqdn }}	{{ sasl_user }}:{{ sasl_passwd }}

# Add {{ notice_sender }} to sender-relay map
file-sender_relay:
  file.append:
    - name: /etc/postfix/sender_relay
    - text: |
        {{ notice_sender }}@{{ smtp_fqdn }}	[{{ smtp_relay }}]:{{ smtp_port }}


# Update hash-file
postmap-sasl_passwd:
  cmd.run:
    - name: '/usr/sbin/postmap /etc/postfix/sasl_passwd'
    - requires:
      - file: 'file-sasl_passwd'

# Update hash-file
postmap-sender_relay:
  cmd.run:
    - name: '/usr/sbin/postmap /etc/postfix/sender_relay'
    - requires:
      - file: 'file-sender_relay'
