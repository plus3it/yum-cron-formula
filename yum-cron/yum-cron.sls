#
# Salt formula to install and configure the yum-cron facility
# onto EL6- and EL7-based systems
#
#################################################################

# Parm/vals for base SASL client setup
{%- set sasl_base = [
       'smtp_sasl_auth_enable = yes',
       'smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd',
       'smtp_sasl_security_options = noanonymous',
       'smtp_sasl_mechanism_filter = plain',
       'smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt',
       'smtp_use_tls = yes',
       'smtp_tls_security_level = encrypt',
] %}

# Need PostFix with cyrus-sasl-plain to act as a SASL-authenticated client
pkg_support:
  pkg.installed:
    - pkgs:
      - postfix
      - cyrus-sasl-plain
      - mailx

# Need this to automate runing of cron update-availability detection
pkg_yum-cron:
  pkg.installed:
    - name: yum-cron
    - allow_updates: True

# Add basic SASL-client parms to Postfix config
{%- for sasl_parm in sasl_base %}
file_postfix-main-{{ sasl_parm }}:
  file.append:
    - name: '/etc/postfix/main.cf'
    - text: '{{ sasl_parm }}'
    - require:
      - pkg: pkg_support

{%- endfor %}

file_postfix-main_sasl-sender:
  file.append:
    - name: '/etc/postfix/main.cf'
    - text: |

        # sender-dependent sasl authentication
        smtp_sender_dependent_authentication = yes
        sender_dependent_relayhost_maps = hash:/etc/postfix/sender_relay
    - require:
      - pkg: pkg_support
