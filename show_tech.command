OUTPUT_FILE="show_tech_$(date '+%Y%m%d_%H%M%S').txt"

echo "Executing diagnostics..." 
echo "===============================" 

echo "$(date '+%Y年%m月%d日%H時%M分%S秒')" >$OUTPUT_FILE 2>&1
echo >>$OUTPUT_FILE
echo "----------------機種情報---------------" >>$OUTPUT_FILE 
sw_vers >$OUTPUT_FILE 2>/dev/null
cat /etc/os-release >>$OUTPUT_FILE 2>>/dev/null

echo "----------------ifconfig---------------" >>$OUTPUT_FILE

echo "Running ifconfig -a..." 
ifconfig -a >>$OUTPUT_FILE 2>/dev/null
ip a >>$OUTPUT_FILE 2>/dev/null

echo >>$OUTPUT_FILE
echo "Querying Public IPv4..."
echo "----------------IPv4---------------" >>$OUTPUT_FILE
curl -4 -m 20 https://ipconfig.io/json >>$OUTPUT_FILE 2>&1

echo >>$OUTPUT_FILE
echo "Querying Public IPv6..."
echo "----------------IPv6---------------" >>$OUTPUT_FILE
curl -6 -m 20  https://ipconfig.io/json >>$OUTPUT_FILE 2>&1

echo >>$OUTPUT_FILE
echo "Testing Routing Table..."
echo "----------------Routing Table---------------" >>$OUTPUT_FILE
netstat -r >>$OUTPUT_FILE 2>&1


echo "Running basic network tests..." 
echo  >>$OUTPUT_FILE
echo "----------------DNS---------------" >>$OUTPUT_FILE
echo "Testing DNS Resolution..."
dig +noedns google.com >>$OUTPUT_FILE 2>&1
dig +noedns vpn1.adm.u-tokyo.ac.jp >>$OUTPUT_FILE 2>&1

echo >>$OUTPUT_FILE
echo "Testing Internet Connectivity... L3"
echo "----------------ping---------------" >>$OUTPUT_FILE
echo "to 8.8.8.8" >>$OUTPUT_FILE
ping -c 4 8.8.8.8 >>$OUTPUT_FILE 2>&1
echo "to vpn1.adm.u-tokyo.ac.jp" >>$OUTPUT_FILE
ping -c 4 vpn1.adm.u-tokyo.ac.jp >>$OUTPUT_FILE 2>&1
echo "Testing Internet Connectivity... L4"
echo >>$OUTPUT_FILE
echo "----------------netcat to VPN server on TCP443---------------" >>$OUTPUT_FILE
nc -t vpn1.adm.u-tokyo.ac.jp 443 >>$OUTPUT_FILE 2>&1

echo >>$OUTPUT_FILE
echo "Tracing route to Google DNS..."
echo "----------------traceroute---------------" >>$OUTPUT_FILE
traceroute -m 15 8.8.8.8 >>$OUTPUT_FILE 2>&1

echo "All diagnostics complete."
