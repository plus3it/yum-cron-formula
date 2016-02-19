#
# Salt state to configure the yum-cron service from external
# data sources (Pillar and grains) and then ensure service has
# been (re)started
#
#################################################################

{%- set this_host = salt['grains.get']('fqdn') %}
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
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-CheckOnly:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^CHECK_ONLY=.*'
    - repl: CHECK_ONLY={{ update_struct.get('check-only', '') }}
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-CheckFirst:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^CHECK_FIRST=.*'
    - repl: CHECK_FIRST={{ update_struct.get('check-first', '') }}
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-DownloadOnly:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^DOWNLOAD_ONLY=.*'
    - repl: DOWNLOAD_ONLY={{ update_struct.get('download-only', '') }}
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-ErrorLevel:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^ERROR_LEVEL=.*'
    - repl: ERROR_LEVEL={{ update_struct.get('error-level', '') }}
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-DebugLevel:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^DEBUG_LEVEL=.*'
    - repl: DEBUG_LEVEL={{ update_struct.get('debug-level', '') }}
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-RandWait:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^RANDOMWAIT=.*'
    - repl: RANDOMWAIT="{{ update_struct.get('randwait', '') }}"
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-MailTo:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^MAILTO=.*'
    - repl: MAILTO="{{ update_struct.get('email-to', '') }}"
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-SysName:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^SYSTEMNAME=.*'
    - repl: SYSTEMNAME="{{ this_host }}"
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-WeekDays:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^DAYS_OF_WEEK=.*'
    - repl: DAYS_OF_WEEK="{{ update_struct.get('dayofweek', '') }}"
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-CleanDay:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^CLEANDAY=.*'
    - repl: CLEANDAY="{{ update_struct.get('cleanday', '') }}"
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-SvcWaits:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^SERVICE_WAITS=.*'
    - repl: SERVICE_WAITS="{{ update_struct.get('svc-waits', '') }}"
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

file-{{ cfgFile }}-SvcWaitTime:
  file.replace:
    - name: '{{ cfgFile }}'
    - pattern: '^SERVICE_WAIT_TIME=.*'
    - repl: SERVICE_WAIT_TIME="{{ update_struct.get('svc-wait-time', '') }}"
    - append_if_not_found : True
    - require:
      - file: file-{{ cfgFile }}-exists

svc-yum_cron-running:
  service.running:
    - name: 'yum-cron'
    - enable: True
    - watch:
      - file: '{{ cfgFile }}'

{%- elif salt['grains.get']('osmajorrelease') == '7' %}
{%- set update_struct = salt['pillar.get']('yum-cron:update-behavior:el7', None) %}
{%- endif %}

