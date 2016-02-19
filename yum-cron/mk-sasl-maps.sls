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
{%- set passwd_file = '/etc/postfix/sasl_passwd' %}
{%- set relay_file = '/etc/postfix/sender_relay' %}


# Add {{ notice_sender }} to SASL password-map
file-sasl_passwd:
  file.append:
    - name: '{{ passwd_file }}'
    - text: |
        {{ notice_sender }}@{{ smtp_fqdn }}	{{ sasl_user }}:{{ sasl_passwd }}

# Add {{ notice_sender }} to sender-relay map
file-sender_relay:
  file.append:
    - name: '{{ relay_file }}'
    - text: |
        {{ notice_sender }}@{{ smtp_fqdn }}	[{{ smtp_relay }}]:{{ smtp_port }}


# Update hash-file
postmap-sasl_passwd:
  cmd.run:
    - name: '/usr/sbin/postmap {{ passwd_file }}'
    - requires:
      - file: 'file-sasl_passwd'

# Update hash-file
postmap-sender_relay:
  cmd.run:
    - name: '/usr/sbin/postmap {{ relay_file }}'
    - requires:
      - file: 'file-sender_relay'

# Update SEL-contexts as necessary
{%- if salt['grains.get']('selinux:enabled') %}
sel-sasl_passwd:
  cmd.run:
    - name: 'chcon --reference=/etc/postfix/main.cf {{ passwd_file }} {{ passwd_file }}.db'
    - requires:
      - cmd: 'postmap-sasl_passwd'

sel-sender_relay:
  cmd.run:
    - name: 'chcon --reference=/etc/postfix/main.cf {{ relay_file }} {{ relay_file }}.db'
    - requires:
      - cmd: 'postmap-sender_relay'
{%- endif %}
