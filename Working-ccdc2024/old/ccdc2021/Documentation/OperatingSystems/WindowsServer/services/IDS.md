# IDS

## Objective
- Detect intrusions on local computer / network


## Security Analysis

- 
-
-
-

## Testing

Scripted: 

-
-
-
-

Active:

-
-
-
-

## Documentation
Install:
- NXLog
- WinPcap
- Snort

Snort Setup:
- After basic install navigate to 'C:\Snort\etc\snort.conf'
- Change file value:
  - HOME_NET: <local IP>
  - EXTERNAL_NET: !HOME_NET
  - RULE_PATH: C:\Snort\rules
  - (Comment Out) SO_RULE_PATH
  - PREPROC_RULE_PATH: C:\Snort\preproc_rules
  - WHITE_LIST_PATH: C:\Snort\rules
  - BLACK_LIST_PATH: C:\Snort\rules
  - (UNCOMMENT) config logdir
  - config logdir: C:\Snort\log
  - dynamicpreprocessor directory: C:\Snort\lib\snort_dynamicpreprocessor
  - dynamicengin: C:\Snort\lib\snort_dynamicengine\sf_engine.dll
  - (Comment Out) dynamicdetection directory
  - For Step 7: Change slashes from / -> \
  
  
Note for future (Snort):
  - has option for outputting log of syslog and log_tcpdump
  - May need to comment out: #    decompress_swf { deflate lzma } \
## Script with Comments

```

```

## ToDo

- [ ]   
- [ ]   
- [ ]   
- [ ]   

## References

- [Snort](https://www.snort.org/downloads)
- [WinPcap](https://www.winpcap.org/)
- [NXLog](https://nxlog.co/products/all/download)
- [NXLog + Snort](https://nxlog.co/documentation/nxlog-user-guide/snort.html)
- [Wireshark](https://www.wireshark.org/#download)
