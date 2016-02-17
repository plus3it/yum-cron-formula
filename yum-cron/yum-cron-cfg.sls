# yum-cron:update-behavior:el6:
# ----------
#    cleanday:
#       0
#    dayofweek:
#       0123456
#    email-to:
#       thomas.jones+ses-test@plus3it.com
#    error-level:
#       0
#    svc-wait-time:
#       300
#    svc-waits:
#       yes
#    systemname:
#       yum-parm:
#################################################################

{%- set cfgFile = '/etc/sysconfig/yum-cron' %}
file-{{ cfgFile }}-exists:
  file.exists:
    - name: '{{ cfgFile }}'


{%- if salt['grains.get']('osmajorrelease') == '6' %}
{%- set update_struct = salt['pillar.get']('yum-cron:update-behavior:el6', None) %}

file-{{ cfgFile }}-YumParm:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^YUM_PARAMETER=.*'
    - repl: YUM_PARAMETER= {{ update_struct.get('yum-parm', '') }}
    - append_if_not_found : True

file-{{ cfgFile }}-CheckOnly:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^CHECK_ONLY=.*'
    - repl: CHECK_ONLY={{ update_struct.get('check-only', '') }}
    - append_if_not_found : True

file-{{ cfgFile }}-CheckFirst:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^CHECK_FIRST=.*'
    - repl: CHECK_FIRST={{ update_struct.get('check-first', '') }}
    - append_if_not_found : True

file-{{ cfgFile }}-DownloadOnly:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^DOWNLOAD_ONLY=.*'
    - repl: DOWNLOAD_ONLY={{ update_struct.get('download-only', '') }}
    - append_if_not_found : True

file-{{ cfgFile }}-ErrorLevel:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^ERROR_LEVEL=.*'
    - repl: ERROR_LEVEL={{ update_struct.get('error-level', '') }}
    - append_if_not_found : True

file-{{ cfgFile }}-DebugLevel:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^DEBUG_LEVEL=.*'
    - repl: DEBUG_LEVEL={{ update_struct.get('debug-level', '') }}
    - append_if_not_found : True

file-{{ cfgFile }}-RandWait:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^RANDOMWAIT=.*'
    - repl: RANDOMWAIT="{{ update_struct.get('randwait', '') }}"
    - append_if_not_found : True

{%- elif salt['grains.get']('osmajorrelease') == '7' %}
{%- set update_struct = salt['pillar.get']('yum-cron:update-behavior:el7', None) %}
{%- endif %}

