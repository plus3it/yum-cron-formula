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
{%- set smtp_relay = salt['pillar.get']('yum-cron:smtp:smtp-relay', None) %}

file-test:
  file.append:
    - name: /tmp/stored-data.txt
    - text: |
        SMTP Host: {{ smtp_host }}
        SMTP Domain: {{ smtp_domain }}
        SMTP FQDN: {{ smtp_fqdn }}
        Sender: {{ notice_sender }}
        Recipient: {{ notice_recipt }}
        SASL User: {{ sasl_user }}
        SASL Password: {{ sasl_passwd }}
        SMTP Relay: {{ smtp_relay }}
