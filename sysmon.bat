copy /z /y "\\domain.com\apps\sysmonconfig-export.xml" "C:\windows\"
sysmon -c c:\windows\sysmonconfig-export.xml

sc query "Sysmon" | Find "RUNNING"
If "%ERRORLEVEL%" EQU "1" (
goto startsysmon
)
:startsysmon
net start Sysmon

If "%ERRORLEVEL%" EQU "1" (
goto installsysmon
)
:installsysmon
"\\domain.com\apps\sysmon.exe" /accepteula -i c:\windows\sysmon-configexport.xml
