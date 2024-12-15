@echo off
setlocal enabledelayedexpansion
set CurrentDirectory="%~dp0"

:execute_all
cls
echo Executing all diagnostics...
echo ================================
set filename=show_tech_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt
echo Save result to %filename%
echo Timestamp: %date%_%time% > %filename%

echo Running systeminfo...
echo -----------------------[systeminfo]----------------------- >> %filename%
systeminfo 1>> %filename% 2>>&1
echo. >> %filename%

echo Running ipconfig -all...
echo -----------------------[ipconfig -all]----------------------- >> %filename%
ipconfig /all 1>> %filename% 2>>&1
echo. >> %filename%

echo Running route print...
echo -----------------------[route print]----------------------- >> %filename%
route print 1>> %filename% 2>>&1
echo. >> %filename%

echo Querying IP...
echo -----------------------[ipconfig.io]----------------------- >> %filename%
echo -----------[IPv4] >> %filename%
curl -4 -m 20 https://ipconfig.io/json 1>> %filename% 2>>&1
echo. >> %filename%

echo -----------[IPv6] >> %filename%
curl -6 -m 20 https://ipconfig.io/json 1>> %filename% 2>>&1
echo. >> %filename%
echo. >> %filename%

echo Testing DNS Resolution...
echo -----------------------[nslookup]----------------------- >> %filename%
echo -----------[nslookup vpn1.adm.u-tokyo.ac.jp] >> %filename%
nslookup vpn1.adm.u-tokyo.ac.jp 1>> %filename% 2>>&1
echo -----------[nslookup www.google.com] >> %filename%
nslookup www.google.com 1>> %filename% 2>>&1
echo. >> %filename%

echo Testing Internet Connectivity...
echo -----------------------[ping]----------------------- >> %filename%
ping 1.1.1.1 -n 4 1>> %filename% 2>>&1
ping vpn1.adm.u-tokyo.ac.jp -n 4 1>> %filename% 2>>&1
echo. >> %filename%

echo Tracing route to Cloudflare DNS...
echo -----------------------[tracert]----------------------- >> %filename%
tracert -h 15 1.1.1.1 1>> %filename% 2>>&1
echo. >> %filename%
echo All diagnostics complete.

pause
goto end

:end
echo Exiting...
exit /b 0
