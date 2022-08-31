# checkmka

Install and configure CheckMK Agent or SNMP.

Usage:
Add to Policyfile.rb run list:
1) Install Agent on node to monitored by CheckMK server;
  'checkmka::agent-cmk'
2) Add scripts to add node to be monitored by CheckMK server via SNMP;
  'checkmka::agent-cmk-snmp'

Environmental variables to be defined:
CMK_TOKEN = The token value taken from the CheckMK Server.
CMA_IP    = The Nat'ed fixed IP address of the node to be monitored.
CMK_IP    = The Nat'ed fixed IP address of the CheckMK Server.
