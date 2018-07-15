alluser-pptp                                                                                        0000644 0000000 0000000 00000002177 13216357414 012144  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
totalaccounts=`cat /var/lib/premium-script/data-user-pptp | wc -l`
echo " " > /tmp/alluser-pptp-data
for((i=1; i<=$totalaccounts; i++ ))
       do  
username=`cat /var/lib/premium-script/data-user-pptp | awk '{print $1}' | head -n $i | tail -n 1`
userpass=`cat /var/lib/premium-script/data-user-pptp | awk '{print $3}' | head -n $i | tail -n 1`
saat_expired=`cat /var/lib/premium-script/data-user-pptp | awk '{print $5}' | head -n $i | tail -n 1`
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')
echo "BYVPN.NET- User : $username dengan password ($userpass) Expire Pada Tanggal : $tanggal_expired_display" >> /tmp/alluser-pptp-data
done
clear
echo "loading..."
sleep 0.5
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "Daftar User VPN PPTP anda adalah:"
  echo "-----------------------------------------------"
cat /tmp/alluser-pptp-data
  echo "-----------------------------------------------"                                                                                                                                                                                                                                                                                                                                                                                                 listpassword                                                                                        0000644 0000000 0000000 00000000104 13216357415 012237  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
curl api.BYVPN.NET/api/password-list.txt
echo ""
echo ""                                                                                                                                                                                                                                                                                                                                                                                                                                                            user-aktif                                                                                          0000644 0000000 0000000 00000002440 13216357415 011560  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
read -p "Masukkan Username Yang Akan Diperpanjang: " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
read -p "Masukkan Tambahan Masa Aktif Account terhitung dari hari ini(Hari): " masa_aktif

today=`date +%s`
masa_aktif_detik=$(( $masa_aktif * 86400 ))
saat_expired=$(($today + $masa_aktif_detik))
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')
clear
echo "Connecting to BYVPN.NET..."
sleep 0.5
echo "Menambah Masa Aktif..."
sleep 0.5
passwd -u $username
usermod -e  $tanggal_expired $username
  egrep "^$username" /etc/passwd >/dev/null
  echo -e "$password\n$password" | passwd $username
  clear
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "Demikian Detail Account Yang Telah Diperpanjang"
  echo "---------------------------------------"
  echo "   Username        : $username"
  echo "   Masa aktif      : $masa_aktif Hari"
  echo "   Tanggal Expired : $tanggal_expired_display"
  echo "--------------------------------------"
  echo " "

else
echo -e "Username ${red}$username${NC} tidak ditemukan di VPS anda"
exit 0
fi                                                                                                                                                                                                                                user-limit                                                                                          0000644 0000000 0000000 00000007044 13216357415 011605  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
MAX=2
if [ -e "/var/log/auth.log" ]; then
        OS=1;
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        OS=2;
        LOG="/var/log/secure";
fi
if [[ ${1+x} ]]; then
        MAX=$1;
fi
echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
echo " "
echo "-----------------------------------------------------------"
echo "User yang login lebih dari Batas Multi login Anda ($MAX) :"
echo "-----------------------------------------------------------"
while :
do
        cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /root/user.txt
        username1=( `cat "/root/user.txt" `);
        i="0";
        for user in "${username1[@]}"
			do
                username[$i]=`echo $user | sed 's/'\''//g'`;
                jumlah[$i]=0;
                i=$i+1;
			done
        cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/log-db.txt
        proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
        for PID in "${proc[@]}"
			do
                cat /tmp/log-db.txt | grep "dropbear\[$PID\]" > /tmp/log-db-pid.txt
                NUM=`cat /tmp/log-db-pid.txt | wc -l`;
                USER=`cat /tmp/log-db-pid.txt | awk '{print $10}' | sed 's/'\''//g'`;
                IP=`cat /tmp/log-db-pid.txt | awk '{print $12}'`;
                if [ $NUM -eq 1 ]; then
                        i=0;
                        for user1 in "${username[@]}"
							do
                                if [ "$USER" == "$user1" ]; then
                                        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
                                        pid[$i]="${pid[$i]} $PID"
                                fi
                                i=$i+1;
							done
                fi
			done
        cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/log-db.txt
        data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
        for PID in "${data[@]}"
			do
                cat /tmp/log-db.txt | grep "sshd\[$PID\]" > /tmp/log-db-pid.txt;
                NUM=`cat /tmp/log-db-pid.txt | wc -l`;
                USER=`cat /tmp/log-db-pid.txt | awk '{print $9}'`;
                IP=`cat /tmp/log-db-pid.txt | awk '{print $11}'`;
                if [ $NUM -eq 1 ]; then
                        i=0;
                        for user1 in "${username[@]}"
							do
                                if [ "$USER" == "$user1" ]; then
                                        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
                                        pid[$i]="${pid[$i]} $PID"
                                fi
                                i=$i+1;
							done
                fi
        done
        j="0";
        for i in ${!username[*]}
			do
                if [ ${jumlah[$i]} -gt $MAX ]; then
                        date=`date +"%Y-%m-%d %X"`;
                        echo "BYVPN.NET - $date - ${username[$i]} - ${jumlah[$i]}";
                        echo "BYVPN.NET - $date - ${username[$i]} - ${jumlah[$i]}" >> /root/log-limit.txt;
                        kill ${pid[$i]};
                        pid[$i]="";
                        j=`expr $j + 1`;
                fi
			done
        if [ $j -gt 0 ]; then
                if [ $OS -eq 1 ]; then
                        service ssh restart > /dev/null 2>&1;
                fi
                if [ $OS -eq 2 ]; then
                        service sshd restart > /dev/null 2>&1;
                fi
                service dropbear restart > /dev/null 2>&1;
                j=0;
		fi
sleep 300;
done                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            autokill                                                                                            0000644 0000000 0000000 00000020722 13133476523 011335  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
if [[ $USER != "root" ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

# go to root
cd

#Cek Curl
if [ ! -e /usr/bin/curl ]; then
	if [[ "$OS" = 'debian' ]]; then
	apt-get -y update && apt-get -y install curl
	else
	yum -y update && yum -y install curl
	fi
fi

if [[ -e /etc/debian_version ]]; then
	OS=debian
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	RCLOCAL='/etc/rc.d/rc.local'
	chmod +x /etc/rc.d/rc.local
else
	echo "Sepertinya Anda tidak menjalankan script ini pada sistem Debian, Ubuntu atau CentOS"
	exit
fi

x=$1

case $x in
0)
	#dropbear
	rm -f /root/dropbearport
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "Dropbear Port:"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		echo "$line ==> Limit $x login"
		#grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL > /dev/null
		#if [[ $? != 0 ]];then
			#sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL
		#fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i $RCLOCAL
	done
	
	echo ""
	rm -f /root/dropbearport
	
	#openssh
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "OpenSSH Port:"
	
	cat > /root/opensshport <<-END
	$opensshport
	END
	
	exec</root/opensshport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		echo "$line ==> Limit $x login"
		#grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL > /dev/null
		#if [[ $? != 0 ]];then
			#sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL
		#fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i $RCLOCAL
	done
	
	echo ""
	rm -f /root/opensshport
	
	sed '/^$/d' $RCLOCAL > /tmp/rc.local
	cat /tmp/rc.local > $RCLOCAL
	$RCLOCAL start
;;
2)
	#dropbear
	rm -f /root/dropbearport
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "Dropbear Port:"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		echo "$line ==> Limit $x login"
		grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL > /dev/null
		if [[ $? != 0 ]];then
			sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL
		fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i $RCLOCAL
	done
	
	echo ""
	rm -f /root/dropbearport
	
	#openssh
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "OpenSSH Port:"
	
	cat > /root/opensshport <<-END
	$opensshport
	END
	
	exec</root/opensshport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		echo "$line ==> Limit $x login"
		grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL > /dev/null
		if [[ $? != 0 ]];then
			sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL
		fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i $RCLOCAL
	done
	
	echo ""
	rm -f /root/opensshport
	
	sed '/^$/d' $RCLOCAL > /tmp/rc.local
	cat /tmp/rc.local > $RCLOCAL
	$RCLOCAL start
;;
3)
	#dropbear
	rm -f /root/dropbearport
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "Dropbear Port:"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		echo "$line ==> Limit $x login"
		grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL > /dev/null
		if [[ $? != 0 ]];then
			sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL
		fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i $RCLOCAL
	done
	
	echo ""
	rm -f /root/dropbearport
	
	#openssh
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo "OpenSSH Port:"
	
	cat > /root/opensshport <<-END
	$opensshport
	END
	
	exec</root/opensshport
	while read line
	do
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 2 -j REJECT//g" -i $RCLOCAL
		sed "s/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above 3 -j REJECT//g" -i $RCLOCAL
		echo "$line ==> Limit $x login"
		grep "iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL > /dev/null
		if [[ $? != 0 ]];then
			sed -i "1 a\iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT" $RCLOCAL
		fi
		#sed "s/#iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/iptables -A INPUT -p tcp --syn --dport $line -m connlimit --connlimit-above $x -j REJECT/g" -i $RCLOCAL
	done
	
	echo ""
	rm -f /root/opensshport
	
	sed '/^$/d' $RCLOCAL > /tmp/rc.local
	cat /tmp/rc.local > $RCLOCAL
	$RCLOCAL start
;;
*)
	echo "Gunakan perintah autokill 2, untuk limit 2 login saja"
	echo "atau autokill 3, untuk melimit max 3 login"
	echo "atau autokill 0, untuk no limit login"
	echo ""
;;
esac

cd ~/
rm -f /root/IP
                                              log-ban                                                                                             0000644 0000000 0000000 00000001154 13216135203 011013  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
echo " "
echo "===============================================";
echo " ";
if [ -e "/root/log-ban.txt" ]; then
echo "User yang diban oleh user-ban adalah";
echo "Waktu - Username - Jumlah Multilogin"
echo "-------------------------------------";
cat /root/log-ban.txt
else
echo " Tidak ada user yang melakukan pelanggaran"
echo " Atau"
echo " Script user-ban belum dijalankan"
fi
echo " ";
echo "===============================================";
echo " ";
echo " ";
                                                                                                                                                                                                                                                                                                                                                                                                                    user-auto-limit                                                                                     0000644 0000000 0000000 00000005023 13133477147 012551  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
if [ ! -e /usr/local/bin/user-auto-limit-script ]; then
echo 'FATAL ERROR'
echo 'Error Code: 404'
echo 'Mohon update premium script Anda!'
fi

echo "--------------------------------------------------"
echo "Menu Sistem Limit User (Kill Multi Login) otomatis"
echo "--------------------------------------------------"
echo "1.  Set Auto Kill Multi Login 3 menit sekali"
echo "2.  Set Auto Kill Multi Login 5 menit sekali"
echo "3.  Set Auto Kill Multi Login 7 menit sekali"
echo "4.  Set Auto Kill Multi Login 10 menit sekali"
echo "5.  Set Auto Kill Multi Login 15 menit sekali"
echo "6.  Set Auto Kill Multi Login 30 menit sekali"
echo "7.  Matikan Auto-Limit"
echo "8.  Lihat log user yang melakukan multilogin"
echo "9.  Hapus log limit"
echo "--------------------------------------------------"
read -p "Tulis Pilihan Anda (angka): " x

if (($x<7)); then
echo " "
echo "--------------------------------------------------"
read -p "jumlah multilogin maksimum yang diizinkan: " max

fi
if test $x -eq 1; then
echo "*/3 * * * *  root /usr/local/bin/user-auto-limit-script $max" > /etc/cron.d/user_auto_limit 
echo "User-Auto-Limit telah berhasil diset 3 menit sekali."
elif test $x -eq 2; then
echo "*/5 * * * *  root /usr/local/bin/user-auto-limit-script $max" > /etc/cron.d/user_auto_limit
echo "User-Auto-Limit telah berhasil diset 5 menit sekali."
elif test $x -eq 3; then
echo "*/7 * * * *  root /usr/local/bin/user-auto-limit-script $max" > /etc/cron.d/user_auto_limit
echo "User-Auto-Limit telah berhasil diset 7 menit sekali."
elif test $x -eq 4; then
echo "*/10 * * * *  root /usr/local/bin/user-auto-limit-script $max" > /etc/cron.d/user_auto_limit
echo "User-Auto-Limit telah berhasil diset 10 menit sekali."
elif test $x -eq 5; then
echo "*/15 * * * *  root /usr/local/bin/user-auto-limit-script $max" > /etc/cron.d/user_auto_limit
echo "User-Auto-Limit telah berhasil diset 15 menit sekali."
elif test $x -eq 6; then
echo "*/30 * * * *  root /usr/local/bin/user-auto-limit-script $max" > /etc/cron.d/user_auto_limit
echo "User-Auto-Limit telah berhasil diset 30 menit sekali."
elif test $x -eq 7; then
rm -f /etc/cron.d/user_auto_limit
echo "User-Auto-Limit telah berhasil dimatikan."
elif test $x -eq 8; then
if [ ! -e /root/log-limit.txt ]; then
	echo "Belum ada user yang melakukan multilogin yang terdeteksi"
	else 
	echo 'Log user yang terdeteksi melakukan multilogin'
	echo "-------"
	cat /root/log-limit.txt
fi
elif test $x -eq 9; then
echo "" > /root/log-limit.txt
echo "Log berhasil dihapus!"
else
echo "Pilihan Tidak Terdapat Di Menu."
exit
fi                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             user-list                                                                                           0000644 0000000 0000000 00000002041 13216360232 011421  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
if [ -f /etc/debian_version ]; then
	UIDN=1000
elif [ -f /etc/redhat-release ]; then
	UIDN=500
else
	UIDN=500
fi

echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
echo " "
echo " [+] รายชื่อผู้ใช้ใน VPS:"
echo " [+] (USERNAME)    -     (EXP DATE)  "
echo "-------------------------------"
while read ceklist
do
        AKUN="$(echo $ceklist | cut -d: -f1)"
        ID="$(echo $ceklist | grep -v nobody | cut -d: -f3)"
        exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
        if [[ $ID -ge $UIDN ]]; then
        printf "%-17s %2s\n" "$AKUN" "$exp"
        fi
done < /etc/passwd
JUMLAH="$(awk -F: '$3 >= '$UIDN' && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo "-------------------------------------"
echo " [+] จำนวนบัญชีที่มีใน VPS ของคุณ : $JUMLAH ผู้ใช้งาน"
echo "-------------------------------------"
echo " ";
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               auto-reboot                                                                                         0000644 0000000 0000000 00000010011 13216361130 011724  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
if [ ! -e /usr/local/bin/reboot_otomatis ]; then
echo '#!/bin/bash' > /usr/local/bin/reboot_otomatis 
echo 'tanggal=$(date +"%m-%d-%Y")' >> /usr/local/bin/reboot_otomatis 
echo 'waktu=$(date +"%T")' >> /usr/local/bin/reboot_otomatis 
echo 'echo "เซิร์ฟเวอร์ได้รับการบูตใหม่เรียบร้อยแล้วในวันที่ $tanggal โมง $waktu." >> /root/log-reboot.txt' >> /usr/local/bin/reboot_otomatis 
echo '/sbin/shutdown -r now' >> /usr/local/bin/reboot_otomatis 
chmod +x /usr/local/bin/reboot_otomatis
fi

echo "-------------------------------------------"
echo " [+] เมนูระบบรีบูตอัตโนมัติ "
echo "-------------------------------------------"
echo " [+] 1.  ตั้งค่าการรีบูตอัตโนมัติ 1 ชั่วโมง"
echo " [+] 2.  ตั้งค่าการรีบูตอัตโนมัติ 6 ชั่วโมง"
echo " [+] 3.  ตั้งค่าการรีบูตอัตโนมัติ 12 ชั่วโมง"
echo " [+] 4.  ตั้งค่าการรีบูตอัตโนมัติ 1 วัน"
echo " [+] 5.  ตั้งค่าการรีบูตอัตโนมัติ 1 สัปดาห์"
echo " [+] 6.  ตั้งค่าการรีบูตอัตโนมัติ 1 เดือน"
echo " [+] 7.  ปิดการรีบูตอัตโนมัติ"
echo " [+] 8.  ดูล็อกการรีบูต"
echo " [+] 9.  ลบล็อกการรีบูตใหม่"
echo "-------------------------------------------"
read -p " [+] โปรดใส่ตัวเลือกของเมนู (ตัวเลข): " x

if test $x -eq 1; then
echo "10 * * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo " [+] การรีบูตอัตโนมัติได้รับการตั้งค่าเรียบร้อยแล้ว 1 ชั่วโมง"
elif test $x -eq 2; then
echo "10 */6 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo " [+] การรีบูตอัตโนมัติได้รับการตั้งค่าเรียบร้อยแล้ว 6 ชั่วโมง"
elif test $x -eq 3; then
echo "10 */12 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo " [+] การรีบูตอัตโนมัติได้รับการตั้งค่าเรียบร้อยแล้ว 12 ชั่วโมง"
elif test $x -eq 4; then
echo "10 0 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo " [+] การรีบูตอัตโนมัติได้รับการตั้งค่าเรียบร้อยแล้ว 1 วัน"
elif test $x -eq 5; then
echo "10 0 */7 * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo " [+] การรีบูตอัตโนมัติได้รับการตั้งค่าเรียบร้อยแล้ว 1 สัปดาห์"
elif test $x -eq 6; then
echo "10 0 1 * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo " [+] การรีบูตอัตโนมัติได้รับการตั้งค่าเรียบร้อยแล้ว 1 เดือน"
elif test $x -eq 7; then
rm -f /etc/cron.d/reboot_otomatis
echo " [+] ปิดใช้งานการรีบูตอัตโนมัติเรียบร้อยแล้ว"
elif test $x -eq 8; then
if [ ! -e /root/log-reboot.txt ]; then
	echo " [+] ไม่พบกิจกรรมรีบูตเลย"
	else 
	echo 'LOG REBOOT'
	echo "-------"
	cat /root/log-reboot.txt
fi
elif test $x -eq 9; then
echo "" > /root/log-reboot.txt
echo " [+] Auto Reboot Log เรียบร้อยแล้ว!"
else
echo " [+] ไม่พบตัวเลือกในเมนู"
exit
fi                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       log-install                                                                                         0000644 0000000 0000000 00000002454 13117543772 011743  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
MYIP=$(wget -qO- ipv4.icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi

echo "DETAIL INSTALASI DEFAULT"
echo "==============================================="
echo "" 
echo "Service" 
echo "-------"  
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:85/openvpn.tar.gz)"  
echo "OpenSSH  : 22, 90, 143"  
echo "Dropbear : 109, 110, 443"  
echo "Squid3   : 80, 8000, 8080 (limit to IP SSH)"  
echo "PPTP VPN : 1723" 
echo "badvpn   : badvpn-udpgw port 7300"  
echo "nginx    : 85"  
echo ""  
echo "Tools"  
echo "-----" 
echo "axel"  
echo "bmon"  
echo "htop"  
echo "iftop"  
echo "mtr"  
echo "" 
echo "Script"  
echo "------" 
echo "Premium Script telah terinstall pada server Anda!" 
echo "Ketik premium-script untuk menampilkan menu dari premium script."
echo "Penjelasan dari kegunaan premium script dapat dilihat di sebsite"  
echo ""  
echo "Fitur lain" 
echo "----------"  
echo "Webmin   : http://$MYIP:10000/"  
echo "vnstat   : http://$MYIP:85/vnstat/"  
echo "MRTG     : http://$MYIP:85/mrtg/"  
echo "Timezone : Asia/Jakarta"  
echo "Fail2Ban : [on]"  
echo "IPv6     : [off]"  
echo "" 
echo "==============================================="  
                                                                                                                                                                                                                    user-auto-limit-script                                                                              0000644 0000000 0000000 00000006510 13133477165 014055  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
MAX=1
if [ -e "/var/log/auth.log" ]; then
        OS=1;
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        OS=2;
        LOG="/var/log/secure";
fi

if [ $OS -eq 1 ]; then
	service ssh restart > /dev/null 2>&1;
fi
if [ $OS -eq 2 ]; then
	service sshd restart > /dev/null 2>&1;
fi
	service dropbear restart > /dev/null 2>&1;
				
if [[ ${1+x} ]]; then
        MAX=$1;
fi

        cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /root/user.txt
        username1=( `cat "/root/user.txt" `);
        i="0";
        for user in "${username1[@]}"
			do
                username[$i]=`echo $user | sed 's/'\''//g'`;
                jumlah[$i]=0;
                i=$i+1;
			done
        cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/log-db.txt
        proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
        for PID in "${proc[@]}"
			do
                cat /tmp/log-db.txt | grep "dropbear\[$PID\]" > /tmp/log-db-pid.txt
                NUM=`cat /tmp/log-db-pid.txt | wc -l`;
                USER=`cat /tmp/log-db-pid.txt | awk '{print $10}' | sed 's/'\''//g'`;
                IP=`cat /tmp/log-db-pid.txt | awk '{print $12}'`;
                if [ $NUM -eq 1 ]; then
                        i=0;
                        for user1 in "${username[@]}"
							do
                                if [ "$USER" == "$user1" ]; then
                                        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
                                        pid[$i]="${pid[$i]} $PID"
                                fi
                                i=$i+1;
							done
                fi
			done
        cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/log-db.txt
        data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
        for PID in "${data[@]}"
			do
                cat /tmp/log-db.txt | grep "sshd\[$PID\]" > /tmp/log-db-pid.txt;
                NUM=`cat /tmp/log-db-pid.txt | wc -l`;
                USER=`cat /tmp/log-db-pid.txt | awk '{print $9}'`;
                IP=`cat /tmp/log-db-pid.txt | awk '{print $11}'`;
                if [ $NUM -eq 1 ]; then
                        i=0;
                        for user1 in "${username[@]}"
							do
                                if [ "$USER" == "$user1" ]; then
                                        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
                                        pid[$i]="${pid[$i]} $PID"
                                fi
                                i=$i+1;
							done
                fi
        done
        j="0";
        for i in ${!username[*]}
			do
                if [ ${jumlah[$i]} -gt $MAX ]; then
                        date=`date +"%Y-%m-%d %X"`;
                        echo "$date - ${username[$i]} - ${jumlah[$i]}";
                        echo "$date - ${username[$i]} - ${jumlah[$i]}" >> /root/log-limit.txt;
                        kill ${pid[$i]};
                        pid[$i]="";
                        j=`expr $j + 1`;
                fi
			done
        if [ $j -gt 0 ]; then
                if [ $OS -eq 1 ]; then
                        service ssh restart > /dev/null 2>&1;
                fi
                if [ $OS -eq 2 ]; then
                        service sshd restart > /dev/null 2>&1;
                fi
                service dropbear restart > /dev/null 2>&1;
                j=0;
		fi                                                                                                                                                                                        user-lock                                                                                           0000644 0000000 0000000 00000001263 13216134012 011376  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
read -p "Masukkan Username yang ingin anda kunci: " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
# proses mengganti passwordnya
passwd -l $username
clear
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "-----------------------------------------------"
  echo -e "Username ${blue}$username${NC} Sudah berhasil di ${red}KUNCI${NC}."
  echo -e "Akses Login untuk username ${blue}$username${NC} sudah kunci"
  echo "-----------------------------------------------"
else
echo "Username tidak ditemukan di server anda"
    exit 1
fi                                                                                                                                                                                                                                                                                                                                             ban.sh                                                                                              0000644 0000000 0000000 00000000045 13117543772 010661  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
#/usr/local/bin/user-ban
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           log-limit                                                                                           0000644 0000000 0000000 00000001165 13216135203 011373  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
echo " "
echo "===============================================";
echo " ";
if [ -e "/root/log-limit.txt" ]; then
echo "User yang dikick oleh user-limit adalah";
echo "Waktu - Username - Jumlah Multilogin"
echo "-------------------------------------";
cat /root/log-limit.txt
else
echo " Tidak ada user yang melakukan pelanggaran"
echo " Atau"
echo " Script user-limit belum dijalankan"
fi
echo " ";
echo "===============================================";
echo " ";
echo " ";
                                                                                                                                                                                                                                                                                                                                                                                                           user-ban                                                                                            0000644 0000000 0000000 00000007102 13216357415 011222  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
MAX=2
if [ -e "/var/log/auth.log" ]; then
        OS=1;
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        OS=2;
        LOG="/var/log/secure";
fi
if [[ ${1+x} ]]; then
        MAX=$1;
fi
echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
echo " "
echo "-----------------------------------------------------------"
echo "User yang login lebih dari Batas Multi login Anda ($MAX) :"
echo "-----------------------------------------------------------"
while :
do
        cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /root/user.txt
        username1=( `cat "/root/user.txt" `);
        i="0";
        for user in "${username1[@]}"
			do
                username[$i]=`echo $user | sed 's/'\''//g'`;
                jumlah[$i]=0;
                i=$i+1;
			done
        cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/log-db.txt
        proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
        for PID in "${proc[@]}"
			do
                cat /tmp/log-db.txt | grep "dropbear\[$PID\]" > /tmp/log-db-pid.txt
                NUM=`cat /tmp/log-db-pid.txt | wc -l`;
                USER=`cat /tmp/log-db-pid.txt | awk '{print $10}' | sed 's/'\''//g'`;
                IP=`cat /tmp/log-db-pid.txt | awk '{print $12}'`;
                if [ $NUM -eq 1 ]; then
                        i=0;
                        for user1 in "${username[@]}"
							do
                                if [ "$USER" == "$user1" ]; then
                                        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
                                        pid[$i]="${pid[$i]} $PID"
                                fi
                                i=$i+1;
							done
                fi
			done
        cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/log-db.txt
        data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
        for PID in "${data[@]}"
			do
                cat /tmp/log-db.txt | grep "sshd\[$PID\]" > /tmp/log-db-pid.txt;
                NUM=`cat /tmp/log-db-pid.txt | wc -l`;
                USER=`cat /tmp/log-db-pid.txt | awk '{print $9}'`;
                IP=`cat /tmp/log-db-pid.txt | awk '{print $11}'`;
                if [ $NUM -eq 1 ]; then
                        i=0;
                        for user1 in "${username[@]}"
							do
                                if [ "$USER" == "$user1" ]; then
                                        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
                                        pid[$i]="${pid[$i]} $PID"
                                fi
                                i=$i+1;
							done
                fi
        done
        j="0";
        for i in ${!username[*]}
			do
                if [ ${jumlah[$i]} -gt $MAX ]; then
                        date=`date +"%Y-%m-%d %X"`;
                        echo "BYVPN.NET - $date - ${username[$i]} - ${jumlah[$i]}";
                        echo "BYVPN.NET - $date - ${username[$i]} - ${jumlah[$i]}" >> /root/log-ban.txt;
                        passwd -l ${username[$i]}
						kill ${pid[$i]};
                        pid[$i]="";
                        j=`expr $j + 1`;
                fi
			done
        if [ $j -gt 0 ]; then
                if [ $OS -eq 1 ]; then
                        service ssh restart > /dev/null 2>&1;
                fi
                if [ $OS -eq 2 ]; then
                        service sshd restart > /dev/null 2>&1;
                fi
                service dropbear restart > /dev/null 2>&1;
                j=0;
		fi
sleep 300;
done                                                                                                                                                                                                                                                                                                                                                                                                                                                              user-log                                                                                            0000644 0000000 0000000 00000002524 13216135174 011242  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi

case $1 in
dropbear)
ps ax|grep dropbear > /tmp/pid.txt
cat $LOG |  grep -i "Password auth succeeded" > /tmp/sukses.txt
perl -pi -e 's/Password auth succeeded for//g' /tmp/sukses.txt
perl -pi -e 's/dropbear/PID/g' /tmp/sukses.txt
;;
openssh)
clear
ps ax|grep sshd > /tmp/pid.txt
cat /var/log/auth.log | grep -i ssh | grep -i "Accepted password for" > /tmp/sukses.txt
perl -pi -e 's/Accepted password for//g' /tmp/sukses.txt
perl -pi -e 's/sshd/PID/g' /tmp/sukses.txt
;;
*)
echo -e "Gunakan perintah ${red}user-log dropbear${NC} untuk memeriksa log user dropbear"
echo -e "Gunakan perintah ${red}user-log openssh${NC} untuk memeriksa log user openssh"
echo " "
echo "================================================="
echo " "
echo " "
exit 1
;;
esac
echo "Memeriksa Log User" > /tmp/hasil.txt
echo "(tanggal - jam - Hostname VPS-  Process ID - UsernameD - IP address" >> /tmp/hasil.txt
echo "===============================================" >> /tmp/hasil.txt
cat /tmp/pid.txt | while read line;do
set -- $line
cat /tmp/sukses.txt | grep $1 >> /tmp/hasil.txt
done
echo "=================================================" >> /tmp/hasil.txt
echo " " >> /tmp/hasil.txt
echo " " >> /tmp/hasil.txt
cat /tmp/hasil.txt
                                                                                                                                                                            bench-network                                                                                       0000644 0000000 0000000 00000000106 13117543772 012254  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
wget freevps.us/downloads/bench.sh -O - -o /dev/null|bash
                                                                                                                                                                                                                                                                                                                                                                                                                                                          pengumuman.sh                                                                                       0000644 0000000 0000000 00000000106 13216133251 012256  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Created by Tae.TaRuMa
curl Tae.TaRuMa/index.html
echo ""                                                                                                                                                                                                                                                                                                                                                                                                                                                          user-delete                                                                                         0000644 0000000 0000000 00000001442 13216360074 011720  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
read -p " [+] ป้อนชื่อผู้ใช้ที่คุณต้องการลบ: " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
# proses mengganti passwordnya
userdel -f $username
clear
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo "                        -----------------------------------------------"
  echo -e "  [+] ชื่อผู้ใช้ $username ถูกลบเรียบร้อยแล้ว "
  echo "                        -----------------------------------------------"
else
echo " [+] ไม่พบชื่อผู้ใช้บนเซิร์ฟเวอร์ของคุณ"
    exit 1
fi                                                                                                                                                                                                                              user-login                                                                                          0000644 0000000 0000000 00000004172 13216135203 011563  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
echo " "
echo "===============================================";
echo " "
echo " "

if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi
		
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
echo "Memerika User Dropbear Yang Login";
echo "(ID - Username - IP)";
echo "-------------------------------------";
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $10}'`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $12}'`;
        if [ $NUM -eq 1 ]; then
                echo "$PID - $USER - $IP";
		fi
done
echo " "
echo "Memerika User OpenSSH Yang Login";
echo "(ID - Username - IP)";
echo "-------------------------------------";
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $9}'`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "$PID - $USER - $IP";
        fi
done
if [ -f "/etc/openvpn/server-vpn.log" ]; then
	line=`cat /etc/openvpn/server-vpn.log | wc -l`
	a=$((3+((line-8)/2)))
	b=$(((line-8)/2))
	echo " "
	echo "Memerika User OpenVPN Yang Login";
	echo "(Username - IP - Terkoneksi Sejak)";
	echo "-------------------------------------";
	cat /etc/openvpn/server-vpn.log | head -n $a | tail -n $b | cut -d "," -f 1,2,5 | sed -e 's/,/   /g' > /tmp/vpn-login-db.txt
	cat /tmp/vpn-login-db.txt
fi

echo " "
echo " "
echo "===============================================";
echo " ";
echo " ";
                                                                                                                                                                                                                                                                                                                                                                                                      diagnosa                                                                                            0000644 0000000 0000000 00000013542 13216357414 011277  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
#inisialisasi
if [[ -e /etc/debian_version ]]; then
	OS=Debian
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=Centos
else
	echo "Mohon maaf, script ini hanya untuk debian/centos"
	exit
fi
if $(uname -m | grep '64'); then
  arch='64 bit'
else
  arch='32 bit'
fi
echo "SOLUSI" > /var/tmp/solusi.txt

# tun/tap
# if [[ ! -e /dev/net/tun ]]; then
	# echo "TUN/TAP: Tidak Berjalan" > /var/tmp/hasil-tuntap.txt
	# echo "- Enable Tun/TAP pada VPS Panel. Jika ternyata sudah enabled, tekan disable, tunggu 5 menit, tekan enable lagi" >> /var/tmp/solusi.txt
	# else
	# echo "TUN/TAP: Normal" > /var/tmp/hasil-tuntap.txt
# fi

# ppp
# if [[ ! -e /dev/ppp ]]; then
	# echo "PPP: Tidak Berjalan" > /var/tmp/hasil-ppp.txt
	# echo "- Enable PPP pada VPS Panel. Jika ternyata sudah enabled, tekan disable, tunggu 5 menit, tekan enable lagi" >> /var/tmp/solusi.txt
	# else
	# echo "PPP: Normal" > /var/tmp/hasil-ppp.txt
# fi

#OpenSSH
netstat -ntlp | grep ssh | awk '{print $4}' | cut -d ":" -f 2 > /var/tmp/openssh.txt
if [[ -s /var/tmp/openssh.txt ]] ; then
cat /var/tmp/openssh.txt  | xargs | sed -e 's/ /,/g' > /var/tmp/openssh2.txt
portopenssh=`cat /var/tmp/openssh2.txt`
echo "OpenSSH: Normal. Berlajan di Port $portopenssh" > /var/tmp/hasil-openssh.txt
else
echo "OpenSSH: Tidak Normal. (Tidak Berjalan)" > /var/tmp/hasil-openssh.txt
if [[ -e /etc/debian_version ]]; then
		echo "- Ketik service ssh restart pada putty" >> /var/tmp/solusi.txt
else [[ -e /etc/centos-release || -e /etc/redhat-release ]];
		echo "- Ketik service sshd restart pada putty" >> /var/tmp/solusi.txt
fi
fi

#Dropbear
netstat -ntlp | grep dropbear | awk '{print $4}' | cut -d ":" -f 2 > /var/tmp/dropbear.txt
if [[ -s /var/tmp/dropbear.txt ]] ; then
cat /var/tmp/dropbear.txt | xargs | sed -e 's/ /,/g' > /var/tmp/dropbear2.txt
portdropbear=`cat /var/tmp/dropbear2.txt`
echo "Dropbear: Normal. Berlajan di Port $portdropbear" > /var/tmp/hasil-dropbear.txt
else
echo "Dropbear: Tidak Normal. (Tidak Berjalan)" > /var/tmp/hasil-dropbear.txt
echo "- Ketik service dropbear restart pada putty" >> /var/tmp/solusi.txt
fi

#Squid Proxy
netstat -ntlp | grep squid | awk '{print $4}' | cut -d ":" -f 4 > /var/tmp/squid.txt
if [[ -s /var/tmp/squid.txt ]] ; then
cat /var/tmp/squid.txt | xargs | sed -e 's/ /,/g' > /var/tmp/squid2.txt
portsquid=`cat /var/tmp/squid2.txt`
echo "Squid: Normal. Berlajan di Port $portsquid" > /var/tmp/hasil-squid.txt
else
echo "Squid: Tidak Normal. (Tidak Berjalan)" > /var/tmp/hasil-squid.txt
if [[ -e /etc/debian_version ]]; then
		echo "- Ketik service squid3 restart pada putty" >> /var/tmp/solusi.txt
else [[ -e /etc/centos-release || -e /etc/redhat-release ]];
		echo "- Ketik service squid restart pada putty" >> /var/tmp/solusi.txt
fi
fi

#OpenVPN
netstat -ntlp | grep openvpn | awk '{print $4}' | cut -d ":" -f 2 > /var/tmp/openvpn.txt
if [[ -s /var/tmp/openvpn.txt ]] ; then
cat /var/tmp/openvpn.txt | xargs | sed -e 's/ /,/g' > /var/tmp/openvpn2.txt
portopenvpn=`cat /var/tmp/openvpn2.txt`
echo "OpenVPN: Normal. Berlajan di Port $portopenvpn" > /var/tmp/hasil-openvpn.txt
else
echo "OpenVPN: Tidak Normal. (Tidak Berjalan)" > /var/tmp/hasil-openvpn.txt
echo "- Ketik service openvpn restart pada putty" >> /var/tmp/solusi.txt
echo "(Apabila muncul tulisan no such device saat openvpn di restart, silahkan disable Tun/Tap lalu enable lagi" >> /var/tmp/solusi.txt
fi

#Webmin
netstat -ntlp | grep 10000 | awk '{print $4}' | cut -d ":" -f 2 > /var/tmp/webmin.txt
if [[ -s /var/tmp/webmin.txt ]] ; then
cat /var/tmp/webmin.txt | xargs | sed -e 's/ /,/g' > /var/tmp/webmin2.txt
portwebmin=`cat /var/tmp/webmin2.txt`
echo "Webmin: Normal. Berlajan di Port $portwebmin" > /var/tmp/hasil-webmin.txt
else
echo "Webmin: Tidak Normal. (Tidak Berjalan)" > /var/tmp/hasil-webmin.txt
echo "- Ketik service webmin restart pada putty" >> /var/tmp/solusi.txt
fi

#nginx 
netstat -ntlp | grep nginx | awk '{print $4}' | cut -d ":" -f 2 > /var/tmp/nginx.txt
if [[ -s /var/tmp/nginx.txt ]] ; then
cat /var/tmp/nginx.txt | xargs | sed -e 's/ /,/g' > /var/tmp/nginx2.txt
portnginx=`cat /var/tmp/nginx2.txt`
echo "nginx: Normal. Berlajan di Port $portnginx" > /var/tmp/hasil-nginx.txt
else
echo "nginx: Tidak Normal. (Tidak Berjalan)" > /var/tmp/hasil-nginx.txt
echo "- Ketik service nginx restart pada putty" >> /var/tmp/solusi.txt
fi

echo "Diagnosa VPS Otomatis"
echo "(Created By Kang Wahid)"
echo "-------------------------------------------"
echo "PENGECEKAN INTERFACE"
echo " "
echo "Operating System: $OS"
echo "Architechture: $arch"
echo "-------------------------------------------"
echo "PENGECEKAN APLIKASI"
echo " "
cat /var/tmp/hasil-openssh.txt
cat /var/tmp/hasil-dropbear.txt
cat /var/tmp/hasil-squid.txt
cat /var/tmp/hasil-openvpn.txt
cat /var/tmp/hasil-webmin.txt
cat /var/tmp/hasil-nginx.txt
echo "-------------------------------------------"
cat /var/tmp/solusi.txt
echo "-------------------------------------------"
echo "Apakah Anda mau menjalankan auto-fix? "
echo "1) Ya"
echo "2) Tidak"
read -p "Tulis Pilihan Anda (angka): " x
if test $x -eq 1; then
if [[ -e /etc/debian_version ]]; then
service nginx start
service php5-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart
service pptpd restart
clear
else [[ -e /etc/centos-release || -e /etc/redhat-release ]];
service nginx start
service php-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service sshd restart
service dropbear restart
service fail2ban restart
service squid restart
service webmin restart
service pptpd restart
service crond start
clear
fi
echo "Diagnosa VPS Otomatis"
echo "(Created By BYVPN.NET)"
echo "-------------------------------------------"
echo "Proses Auto Fix Telah Selesai."
# runs this if option 2 is selected
elif test $x -eq 2; then
exit
else
echo "Pilihan tidak terdapat di menu."
exit
fi
                                                                                                                                                              premium-script                                                                                      0000644 0000000 0000000 00000021422 13216222304 012453  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash

if [[ -e /etc/debian_version ]]; then
	OS=debian
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	RCLOCAL='/etc/rc.d/rc.local'
	chmod +x /etc/rc.d/rc.local
else
	echo "ดูเหมือนว่าคุณไม่ได้ใช้ตัวติดตั้งนี้ในระบบ Debian, Ubuntu หรือ CentOS"
	exit
fi
color1='\e[031;1m'
color2='\e[34;1m'
color3='\e[0m'
	  echo  "--------------------------------------------" 

	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
	
	echo -e " [+] \e[032;1mCPU model:\e[0m $cname"
	echo -e " [+] \e[032;1mNumber of cores:\e[0m $cores"
	echo -e " [+] \e[032;1mCPU frequency:\e[0m $freq MHz"
	echo -e " [+] \e[032;1mTotal amount of ram:\e[0m $tram MB"
	echo -e " [+] \e[032;1mTotal amount of swap:\e[0m $swap MB"
	echo -e " [+] \e[032;1mSystem uptime:\e[0m $up"
	echo  "--------------------------------------------" 
	echo -e " [+] ${color1}1${color3}.  สร้างบัญชีแบบกำหนดเอง"
	echo -e " [+] ${color1}2${color3}.  สร้างบัญชีแบบอัตโนมัติ เลือกจำนวน บัญชี"
	echo -e " [+] ${color1}3${color3}.  สร้างบัญชีแบบทดลองใช้"
	echo -e " [+] ${color1}4${color3}.  อัปเดตวันใช้งานของผู้ใช้"
	echo -e " [+] ${color1}5${color3}.  เปลี่ยนรหัสผ่านของผู้ใช้"
	echo -e " [+] ${color1}6${color3}.  ผู้ใช้ที่ถูกแบนที่เข้าสู่ระบบหลายบัญชีของผู้ใช้"
	echo -e " [+] ${color1}7${color3}.  ผู้ใช้ที่ไม่ได้รับอนุญาต"
	echo -e " [+] ${color1}8${color3}.  ล็อคผู้ใช้ของผู้ใช้"
	echo -e " [+] ${color1}9${color3}.  ปลดล็อคผู้ใช้ของผู้ใช้"
	echo -e " [+] ${color1}10${color3}. ลบบัญชีของผู้ใช้"
	echo -e " [+] ${color1}11${color3}. ดูรายละเอียดผู้ใช้"
	echo -e " [+] ${color1}12${color3}. แสดงรายชื่อผู้ใช้"
	echo -e " [+] ${color1}13${color3}. ตรวจสอบการเข้าสู่ระบบของผู้ใช้"
	echo -e " [+] ${color1}14${color3}. ดูบันทึกการเข้าสู่ระบบของผู้ใช้"
	echo -e " [+] ${color1}15${color3}. กำจัดการเข้าสู่ระบบแบบซ้อน"
	echo -e " [+] ${color1}16${color3}. แสดงผู้ใช้ที่ไกล้จะหมดอายุ"
	echo -e " [+] ${color1}17${color3}. แสดงผู้ใช้ที่หมดอายุแล้ว"
	echo -e " [+] ${color1}18${color3}. ลบผู้ใช้ที่หมดอายุแล้ว"
	echo -e " [+] ${color1}19${color3}. ล็อกผู้ใช้ที่หมดอายุแล้ว"
	echo -e " [+] ${color1}20${color3}. ดูรายชื่อผู้ใช้ที่สนใจ"
	echo -e " [+] ${color1}21${color3}. ดูรายชื่อผู้ใช้ที่ถูกสั่งห้าม"
	echo -e " [+] ${color1}22${color3}. สร้างบัญชี PPTP VPN"
	echo -e " [+] ${color1}23${color3}. นำบัญชี PPTP VPN ออก"
	echo -e " [+] ${color1}24${color3}. ดูรายละเอียดบัญชี PPTP VPN"
	echo -e " [+] ${color1}25${color3}. ตรวจสอบการเข้าสู่ระบบ PPTP VPN"
	echo -e " [+] ${color1}26${color3}. ดูรายชื่อผู้ใช้ PPTP VPN"
	echo -e " [+] ${color1}27${color3}. ทดสอบความเร็ว"
	echo -e " [+] ${color1}28${color3}. มาตรฐานเซิร์ฟเวอร์"
	echo -e " [+] ${color1}29${color3}. ดูการใช้ RAM ของเซิร์ฟเวอร์"
if [[ "$OS" = 'debian' ]]; then 
	echo -e " [+] ${color1}30${color3}. รีสตาร์ท OpenSSH"
	echo -e " [+] ${color1}31${color3}. รีสตาร์ท DropBear"
	echo -e " [+] ${color1}32${color3}. รีสตาร์ท OpenVPN"
	echo -e " [+] ${color1}33${color3}. รีสตาร์ท PPTPVPN"
	echo -e " [+] ${color1}34${color3}. รีสตาร์ท Webmin"
	echo -e " [+] ${color1}35${color3}. รีสตาร์ท SquidProxy"
else
	echo -e " [+] ${color1}30${color3}. รีสตาร์ท OpenSSH"
	echo -e " [+] ${color1}31${color3}. รีสตาร์ท DropBear"
	echo -e " [+] ${color1}32${color3}. รีสตาร์ท OpenVPN"
	echo -e " [+] ${color1}33${color3}. รีสตาร์ท PPTPVPN"
	echo -e " [+] ${color1}34${color3}. รีสตาร์ท Webmin"
	echo -e " [+] ${color1}35${color3}. รีสตาร์ท SquidProxy"
fi
	echo -e " [+] ${color1}36${color3}. แก้ไขพอร์ตเซิร์ฟเวอร์"
	echo -e " [+] ${color1}37${color3}. ตั้งค่าเซิร์ฟเวอร์รีบูตอัตโนมัติ"
	echo -e " [+] ${color1}38${color3}. รีสตาร์ทเซิร์ฟเวอร์"
	echo -e " [+] ${color1}39${color3}. เปลี่ยนรหัสผ่านเซิร์ฟเวอร์"
	echo -e " [+] ${color1}40${color3}. ดูบันทึกการติดตั้ง"
	echo -e " [+] ${color1}41${color3}. อัปเดตเดี๋ยวนี้"
	echo -e ""
	echo  "------------ พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) ------------" 
	echo -e ""
	read -p " [+] โปรดใส่ตัวเลือกของเมนู (ตัวเลข): " x
if test $x -eq 1; then
user-add
elif test $x -eq 2; then
user-generate
elif test $x -eq 3; then
trial
elif test $x -eq 4; then
user-aktif
elif test $x -eq 5; then
user-password
elif test $x -eq 6; then
read -p " [+] กรอกจำนวนเงินเข้าสู่ระบบสูงสุด (1-2): " MULTILOGIN
user-ban $MULTILOGIN
elif test $x -eq 7; then
user-unban
elif test $x -eq 8; then
user-lock
elif test $x -eq 9; then
user-unlock
elif test $x -eq 10; then
user-delete
elif test $x -eq 11; then
user-detail
elif test $x -eq 12; then
user-list
elif test $x -eq 13; then
user-login
elif test $x -eq 14; then
user-log
elif test $x -eq 15; then
read -p " [+] กรอกจำนวนเงินเข้าสู่ระบบสูงสุด (1-2): " MULTILOGIN
user-limit $MULTILOGIN
elif test $x -eq 16; then
infouser
elif test $x -eq 17; then
expireduser
elif test $x -eq 18; then
user-delete-expired
elif test $x -eq 19; then
clear
echo " [+] สคริปต์นี้จะทำงานโดยอัตโนมัติทุกๆ 12 ชั่วโมง"
echo " [+] คุณไม่จำเป็นต้องเรียกใช้ด้วยตนเอง"
echo " [+] หากคุณยังต้องการเรียกใช้สคริปต์นี้ให้พิมพ์ user-expire"
elif test $x -eq 20; then
log-limit
elif test $x -eq 21; then
log-ban
elif test $x -eq 22; then
user-add-pptp
elif test $x -eq 23; then
user-delete-pptp
elif test $x -eq 24; then
user-detail-pptp
elif test $x -eq 25; then
user-login-pptp
elif test $x -eq 26; then
alluser-pptp
elif test $x -eq 27; then
speedtest --share
elif test $x -eq 28; then
bench-network
elif test $x -eq 29; then
ram
elif test $x -eq 30; then
	if [[ "$OS" = 'debian' ]]; then 
		/etc/init.d/ssh restart 
	else 
		/etc/init.d/sshd restart 
	fi
elif test $x -eq 31; then
/etc/init.d/dropbear restart
elif test $x -eq 32; then
/etc/init.d/openvpn restart
elif test $x -eq 33; then
	if [[ "$OS" = 'debian' ]]; then 
		/etc/init.d/pptpd restart 
	else 
		/etc/init.d/pptpd restart 
	fi
elif test $x -eq 34; then
/etc/init.d/webmin restart
elif test $x -eq 35; then
	if [[ "$OS" = 'debian' ]]; then 
		/etc/init.d/squid3 restart 
	else 
		/etc/init.d/squid restart 
	fi
elif test $x -eq 36; then
edit-port
elif test $x -eq 37; then
auto-reboot
elif test $x -eq 38; then
reboot
elif test $x -eq 39; then
passwd
elif test $x -eq 40; then
log-install
elif test $x -eq 41; then
wget https://dl.dropboxusercontent.com/s/vcd7jdd7i2bg5bd/install-premiumscript.sh -O - -o /dev/null|sh
else
echo " [+] โปรดใส่ตัวเลขให้ถูกต้อง (ไม่พบตัวเลือกเมนู)"
exit
fi                                                                                                                                                                                                                                              user-delete-expired                                                                                 0000644 0000000 0000000 00000003333 13216357415 013364  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
if [ ! -f /usr/local/bin/deleteduser ]; then
    echo "echo "Script Created By BYVPN.NET"" > /usr/local/bin/deleteduser
	chmod +x /usr/local/bin/deleteduser
fi
hariini=`date +%d-%m-%Y`
echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
echo " "
echo "--------------------------------------"
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
       do
       tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
       username=`echo $tuserval | cut -f1 -d:`
       userexp=`echo $tuserval | cut -f2 -d:`
       userexpireinseconds=$(( $userexp * 86400 ))
       tglexp=`date -d @$userexpireinseconds`             
       tgl=`echo $tglexp |awk -F" " '{print $3}'`
       while [ ${#tgl} -lt 2 ]
       do
           tgl="0"$tgl
       done
       while [ ${#username} -lt 15 ]
       do
           username=$username" " 
       done
       bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
       echo "echo "BYVPN.NET- User : $username Expire Pada Tanggal : $tgl $bulantahun"" >> /usr/local/bin/alluser
       todaystime=`date +%s`
       if [ $userexpireinseconds -ge $todaystime ] ;
           then
			:
       else
       echo "echo "BYVPN.NET- Username : $username sudah expired Pada Tanggal: $tgl $bulantahun dan telah di delete pada tanggal: $hariini "" >> /usr/local/bin/deleteduser
	   echo "Username $username yang expired pada $tgl $bulantahun telah berhasil dihapus dari sistem pada $hariini"
       userdel $username
       fi
done
echo " "
echo "Script telah berhasil dieksekusi"
echo "--------------------------------------"
echo " "                                                                                                                                                                                                                                                                                                     user-login-pptp                                                                                     0000644 0000000 0000000 00000001067 13216135203 012544  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
last | grep ppp | grep still | awk '{print " ",$1," - " $3 }' > /tmp/login-db-pptp.txt;
echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
echo " "
echo "===============================================";
echo " "
echo " "
echo "Memeriksa User PPTP VPN Yang Login";
echo "(Username - IP)";
echo "-------------------------------------";
cat /tmp/login-db-pptp.txt
echo " "
echo " "
echo " "
echo "===============================================";
echo " ";
echo " ";                                                                                                                                                                                                                                                                                                                                                                                                                                                                         edit-port                                                                                           0000644 0000000 0000000 00000001507 13133476545 011424  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
while :
do
	clear
	echo "Menu Pilihan Edit Port"
	echo -e "\e[031;1m 1\e[0m) Edit Port OpenSSH (\e[34;1medit-port-openssh\e[0m)"
	echo -e "\e[031;1m 2\e[0m) Edit Port Dropbear (\e[34;1medit-port-dropbear\e[0m)"
	echo -e "\e[031;1m 3\e[0m) Edit Port Squid Proxy (\e[34;1medit-port-squid\e[0m)"
	echo -e "\e[031;1m 4\e[0m) Edit Port OpenVPN (\e[34;1medit-port-openvpn\e[0m)"
	echo ""
	echo -e "\e[031;1m x\e[0m) Exit"
	echo ""
	read -p "Masukkan pilihan anda, kemudian tekan tombol ENTER: " option2
	case $option2 in
		1)
		clear
		edit-port-openssh
		exit
		;;
		2)
		clear
		edit-port-dropbear
		exit
		;;
		3)
		clear
		edit-port-squid
		exit
		;;
		4)
		clear
		edit-port-openvpn
		exit
		;;
		x)
		clear
		exit
		;;
	esac
done
cd
                                                                                                                                                                                         ram                                                                                                 0000644 0000000 0000000 00000052362 13117543772 010300  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/usr/bin/env python

# Try to determine how much RAM is currently being used per program.
# Note per _program_, not per process. So for example this script
# will report RAM used by all httpd process together. In detail it reports:
# sum(private RAM for program processes) + sum(Shared RAM for program processes)
# The shared RAM is problematic to calculate, and this script automatically
# selects the most accurate method available for your kernel.

# Licence: LGPLv2
# Author:  P@draigBrady.com
# Source:  http://www.pixelbeat.org/scripts/ps_mem.py

# V1.0      06 Jul 2005     Initial release
# V1.1      11 Aug 2006     root permission required for accuracy
# V1.2      08 Nov 2006     Add total to output
#                           Use KiB,MiB,... for units rather than K,M,...
# V1.3      22 Nov 2006     Ignore shared col from /proc/$pid/statm for
#                           2.6 kernels up to and including 2.6.9.
#                           There it represented the total file backed extent
# V1.4      23 Nov 2006     Remove total from output as it's meaningless
#                           (the shared values overlap with other programs).
#                           Display the shared column. This extra info is
#                           useful, especially as it overlaps between programs.
# V1.5      26 Mar 2007     Remove redundant recursion from human()
# V1.6      05 Jun 2007     Also report number of processes with a given name.
#                           Patch from riccardo.murri@gmail.com
# V1.7      20 Sep 2007     Use PSS from /proc/$pid/smaps if available, which
#                           fixes some over-estimation and allows totalling.
#                           Enumerate the PIDs directly rather than using ps,
#                           which fixes the possible race between reading
#                           RSS with ps, and shared memory with this program.
#                           Also we can show non truncated command names.
# V1.8      28 Sep 2007     More accurate matching for stats in /proc/$pid/smaps
#                           as otherwise could match libraries causing a crash.
#                           Patch from patrice.bouchand.fedora@gmail.com
# V1.9      20 Feb 2008     Fix invalid values reported when PSS is available.
#                           Reported by Andrey Borzenkov <arvidjaar@mail.ru>
# V3.8      17 Jun 2016
#   http://github.com/pixelb/scripts/commits/master/scripts/ps_mem.py

# Notes:
#
# All interpreted programs where the interpreter is started
# by the shell or with env, will be merged to the interpreter
# (as that's what's given to exec). For e.g. all python programs
# starting with "#!/usr/bin/env python" will be grouped under python.
# You can change this by using the full command line but that will
# have the undesirable affect of splitting up programs started with
# differing parameters (for e.g. mingetty tty[1-6]).
#
# For 2.6 kernels up to and including 2.6.13 and later 2.4 redhat kernels
# (rmap vm without smaps) it can not be accurately determined how many pages
# are shared between processes in general or within a program in our case:
# http://lkml.org/lkml/2005/7/6/250
# A warning is printed if overestimation is possible.
# In addition for 2.6 kernels up to 2.6.9 inclusive, the shared
# value in /proc/$pid/statm is the total file-backed extent of a process.
# We ignore that, introducing more overestimation, again printing a warning.
# Since kernel 2.6.23-rc8-mm1 PSS is available in smaps, which allows
# us to calculate a more accurate value for the total RAM used by programs.
#
# Programs that use CLONE_VM without CLONE_THREAD are discounted by assuming
# they're the only programs that have the same /proc/$PID/smaps file for
# each instance.  This will fail if there are multiple real instances of a
# program that then use CLONE_VM without CLONE_THREAD, or if a clone changes
# its memory map while we're checksumming each /proc/$PID/smaps.
#
# I don't take account of memory allocated for a program
# by other programs. For e.g. memory used in the X server for
# a program could be determined, but is not.
#
# FreeBSD is supported if linprocfs is mounted at /compat/linux/proc/
# FreeBSD 8.0 supports up to a level of Linux 2.6.16

import getopt
import time
import errno
import os
import sys

# The following exits cleanly on Ctrl-C or EPIPE
# while treating other exceptions as before.
def std_exceptions(etype, value, tb):
    sys.excepthook = sys.__excepthook__
    if issubclass(etype, KeyboardInterrupt):
        pass
    elif issubclass(etype, IOError) and value.errno == errno.EPIPE:
        pass
    else:
        sys.__excepthook__(etype, value, tb)
sys.excepthook = std_exceptions

#
#   Define some global variables
#

PAGESIZE = os.sysconf("SC_PAGE_SIZE") / 1024 #KiB
our_pid = os.getpid()

have_pss = 0
have_swap_pss = 0

class Proc:
    def __init__(self):
        uname = os.uname()
        if uname[0] == "FreeBSD":
            self.proc = '/compat/linux/proc'
        else:
            self.proc = '/proc'

    def path(self, *args):
        return os.path.join(self.proc, *(str(a) for a in args))

    def open(self, *args):
        try:
            if sys.version_info < (3,):
                return open(self.path(*args))
            else:
                return open(self.path(*args), errors='ignore')
        except (IOError, OSError):
            val = sys.exc_info()[1]
            if (val.errno == errno.ENOENT or # kernel thread or process gone
                val.errno == errno.EPERM):
                raise LookupError
            raise

proc = Proc()


#
#   Functions
#

def parse_options():
    try:
        long_options = [
            'split-args',
            'help',
            'total',
            'discriminate-by-pid',
            'swap'
        ]
        opts, args = getopt.getopt(sys.argv[1:], "shtdSp:w:", long_options)
    except getopt.GetoptError:
        sys.stderr.write(help())
        sys.exit(3)

    if len(args):
        sys.stderr.write("Extraneous arguments: %s\n" % args)
        sys.exit(3)

    # ps_mem.py options
    split_args = False
    pids_to_show = None
    discriminate_by_pid = False
    show_swap = False
    watch = None
    only_total = False

    for o, a in opts:
        if o in ('-s', '--split-args'):
            split_args = True
        if o in ('-t', '--total'):
            only_total = True
        if o in ('-d', '--discriminate-by-pid'):
            discriminate_by_pid = True
        if o in ('-S', '--swap'):
            show_swap = True
        if o in ('-h', '--help'):
            sys.stdout.write(help())
            sys.exit(0)
        if o in ('-p',):
            try:
                pids_to_show = [int(x) for x in a.split(',')]
            except:
                sys.stderr.write(help())
                sys.exit(3)
        if o in ('-w',):
            try:
                watch = int(a)
            except:
                sys.stderr.write(help())
                sys.exit(3)

    return (
        split_args,
        pids_to_show,
        watch,
        only_total,
        discriminate_by_pid,
        show_swap
    )


def help():
    help_msg = 'Usage: ps_mem [OPTION]...\n' \
        'Show program core memory usage\n' \
        '\n' \
        '  -h, -help                   Show this help\n' \
        '  -p <pid>[,pid2,...pidN]     Only show memory usage PIDs in the '\
        'specified list\n' \
        '  -s, --split-args            Show and separate by, all command line'\
        ' arguments\n' \
        '  -t, --total                 Show only the total value\n' \
        '  -d, --discriminate-by-pid   Show by process rather than by program\n' \
        '  -S, --swap                  Show swap information\n' \
        '  -w <N>                      Measure and show process memory every'\
        ' N seconds\n'

    return help_msg


# (major,minor,release)
def kernel_ver():
    kv = proc.open('sys/kernel/osrelease').readline().split(".")[:3]
    last = len(kv)
    if last == 2:
        kv.append('0')
    last -= 1
    while last > 0:
        for char in "-_":
            kv[last] = kv[last].split(char)[0]
        try:
            int(kv[last])
        except:
            kv[last] = 0
        last -= 1
    return (int(kv[0]), int(kv[1]), int(kv[2]))


#return Private,Shared
#Note shared is always a subset of rss (trs is not always)
def getMemStats(pid):
    global have_pss
    global have_swap_pss
    mem_id = pid #unique
    Private_lines = []
    Shared_lines = []
    Pss_lines = []
    Rss = (int(proc.open(pid, 'statm').readline().split()[1])
           * PAGESIZE)
    Swap_lines = []
    Swap_pss_lines = []

    Swap = 0
    Swap_pss = 0

    if os.path.exists(proc.path(pid, 'smaps')):  # stat
        lines = proc.open(pid, 'smaps').readlines()  # open
        # Note we checksum smaps as maps is usually but
        # not always different for separate processes.
        mem_id = hash(''.join(lines))
        for line in lines:
            if line.startswith("Shared"):
                Shared_lines.append(line)
            elif line.startswith("Private"):
                Private_lines.append(line)
            elif line.startswith("Pss"):
                have_pss = 1
                Pss_lines.append(line)
            elif line.startswith("Swap:"):
                Swap_lines.append(line)
            elif line.startswith("SwapPss:"):
                have_swap_pss = 1
                Swap_pss_lines.append(line)
        Shared = sum([int(line.split()[1]) for line in Shared_lines])
        Private = sum([int(line.split()[1]) for line in Private_lines])
        #Note Shared + Private = Rss above
        #The Rss in smaps includes video card mem etc.
        if have_pss:
            pss_adjust = 0.5 # add 0.5KiB as this avg error due to truncation
            Pss = sum([float(line.split()[1])+pss_adjust for line in Pss_lines])
            Shared = Pss - Private
        # Note that Swap = Private swap + Shared swap.
        Swap = sum([int(line.split()[1]) for line in Swap_lines])
        if have_swap_pss:
            # The kernel supports SwapPss, that shows proportional swap share.
            # Note that Swap - SwapPss is not Private Swap.
            Swap_pss = sum([int(line.split()[1]) for line in Swap_pss_lines])
    elif (2,6,1) <= kernel_ver() <= (2,6,9):
        Shared = 0 #lots of overestimation, but what can we do?
        Private = Rss
    else:
        Shared = int(proc.open(pid, 'statm').readline().split()[2])
        Shared *= PAGESIZE
        Private = Rss - Shared
    return (Private, Shared, mem_id, Swap, Swap_pss)


def getCmdName(pid, split_args, discriminate_by_pid):
    cmdline = proc.open(pid, 'cmdline').read().split("\0")
    if cmdline[-1] == '' and len(cmdline) > 1:
        cmdline = cmdline[:-1]

    path = proc.path(pid, 'exe')
    try:
        path = os.readlink(path)
        # Some symlink targets were seen to contain NULs on RHEL 5 at least
        # https://github.com/pixelb/scripts/pull/10, so take string up to NUL
        path = path.split('\0')[0]
    except OSError:
        val = sys.exc_info()[1]
        if (val.errno == errno.ENOENT or # either kernel thread or process gone
            val.errno == errno.EPERM):
            raise LookupError
        raise

    if split_args:
        return " ".join(cmdline)
    if path.endswith(" (deleted)"):
        path = path[:-10]
        if os.path.exists(path):
            path += " [updated]"
        else:
            #The path could be have prelink stuff so try cmdline
            #which might have the full path present. This helped for:
            #/usr/libexec/notification-area-applet.#prelink#.fX7LCT (deleted)
            if os.path.exists(cmdline[0]):
                path = cmdline[0] + " [updated]"
            else:
                path += " [deleted]"
    exe = os.path.basename(path)
    cmd = proc.open(pid, 'status').readline()[6:-1]
    if exe.startswith(cmd):
        cmd = exe #show non truncated version
        #Note because we show the non truncated name
        #one can have separated programs as follows:
        #584.0 KiB +   1.0 MiB =   1.6 MiB    mozilla-thunder (exe -> bash)
        # 56.0 MiB +  22.2 MiB =  78.2 MiB    mozilla-thunderbird-bin
    if sys.version_info >= (3,):
        cmd = cmd.encode(errors='replace').decode()
    if discriminate_by_pid:
        cmd = '%s [%d]' % (cmd, pid)
    return cmd


#The following matches "du -h" output
#see also human.py
def human(num, power="Ki", units=None):
    if units is None:
        powers = ["Ki", "Mi", "Gi", "Ti"]
        while num >= 1000: #4 digits
            num /= 1024.0
            power = powers[powers.index(power)+1]
        return "%.1f %sB" % (num, power)
    else:
        return "%.f" % ((num * 1024) / units)


def cmd_with_count(cmd, count):
    if count > 1:
        return "%s (%u)" % (cmd, count)
    else:
        return cmd

#Warn of possible inaccuracies
#2 = accurate & can total
#1 = accurate only considering each process in isolation
#0 = some shared mem not reported
#-1= all shared mem not reported
def shared_val_accuracy():
    """http://wiki.apache.org/spamassassin/TopSharedMemoryBug"""
    kv = kernel_ver()
    pid = os.getpid()
    if kv[:2] == (2,4):
        if proc.open('meminfo').read().find("Inact_") == -1:
            return 1
        return 0
    elif kv[:2] == (2,6):
        if os.path.exists(proc.path(pid, 'smaps')):
            if proc.open(pid, 'smaps').read().find("Pss:")!=-1:
                return 2
            else:
                return 1
        if (2,6,1) <= kv <= (2,6,9):
            return -1
        return 0
    elif kv[0] > 2 and os.path.exists(proc.path(pid, 'smaps')):
        return 2
    else:
        return 1

def show_shared_val_accuracy( possible_inacc, only_total=False ):
    level = ("Warning","Error")[only_total]
    if possible_inacc == -1:
        sys.stderr.write(
         "%s: Shared memory is not reported by this system.\n" % level
        )
        sys.stderr.write(
         "Values reported will be too large, and totals are not reported\n"
        )
    elif possible_inacc == 0:
        sys.stderr.write(
         "%s: Shared memory is not reported accurately by this system.\n" % level
        )
        sys.stderr.write(
         "Values reported could be too large, and totals are not reported\n"
        )
    elif possible_inacc == 1:
        sys.stderr.write(
         "%s: Shared memory is slightly over-estimated by this system\n"
         "for each program, so totals are not reported.\n" % level
        )
    sys.stderr.close()
    if only_total and possible_inacc != 2:
        sys.exit(1)


def get_memory_usage(pids_to_show, split_args, discriminate_by_pid,
                     include_self=False, only_self=False):
    cmds = {}
    shareds = {}
    mem_ids = {}
    count = {}
    swaps = {}
    shared_swaps = {}
    for pid in os.listdir(proc.path('')):
        if not pid.isdigit():
            continue
        pid = int(pid)

        # Some filters
        if only_self and pid != our_pid:
            continue
        if pid == our_pid and not include_self:
            continue
        if pids_to_show is not None and pid not in pids_to_show:
            continue

        try:
            cmd = getCmdName(pid, split_args, discriminate_by_pid)
        except LookupError:
            #operation not permitted
            #kernel threads don't have exe links or
            #process gone
            continue

        try:
            private, shared, mem_id, swap, swap_pss = getMemStats(pid)
        except RuntimeError:
            continue #process gone
        if shareds.get(cmd):
            if have_pss: #add shared portion of PSS together
                shareds[cmd] += shared
            elif shareds[cmd] < shared: #just take largest shared val
                shareds[cmd] = shared
        else:
            shareds[cmd] = shared
        cmds[cmd] = cmds.setdefault(cmd, 0) + private
        if cmd in count:
            count[cmd] += 1
        else:
            count[cmd] = 1
        mem_ids.setdefault(cmd, {}).update({mem_id: None})

        # Swap (overcounting for now...)
        swaps[cmd] = swaps.setdefault(cmd, 0) + swap
        if have_swap_pss:
            shared_swaps[cmd] = shared_swaps.setdefault(cmd, 0) + swap_pss
        else:
            shared_swaps[cmd] = 0

    # Total swaped mem for each program
    total_swap = 0

    # Total swaped shared mem for each program
    total_shared_swap = 0

    # Add shared mem for each program
    total = 0

    for cmd in cmds:
        cmd_count = count[cmd]
        if len(mem_ids[cmd]) == 1 and cmd_count > 1:
            # Assume this program is using CLONE_VM without CLONE_THREAD
            # so only account for one of the processes
            cmds[cmd] /= cmd_count
            if have_pss:
                shareds[cmd] /= cmd_count
        cmds[cmd] = cmds[cmd] + shareds[cmd]
        total += cmds[cmd]  # valid if PSS available
        total_swap += swaps[cmd]
        if have_swap_pss:
            total_shared_swap += shared_swaps[cmd]

    sorted_cmds = sorted(cmds.items(), key=lambda x:x[1])
    sorted_cmds = [x for x in sorted_cmds if x[1]]

    return sorted_cmds, shareds, count, total, swaps, shared_swaps, \
        total_swap, total_shared_swap


def print_header(show_swap, discriminate_by_pid):
    output_string = " Private  +   Shared  =  RAM used"
    if show_swap:
        if have_swap_pss:
            output_string += " " * 5 + "Shared Swap"
        output_string += "   Swap used"
    output_string += "\tProgram"
    if discriminate_by_pid:
        output_string += "[pid]"
    output_string += "\n\n"
    sys.stdout.write(output_string)


def print_memory_usage(sorted_cmds, shareds, count, total, swaps, total_swap,
                       shared_swaps, total_shared_swap, show_swap):
    for cmd in sorted_cmds:

        output_string = "%9s + %9s = %9s"
        output_data = (human(cmd[1]-shareds[cmd[0]]),
                       human(shareds[cmd[0]]), human(cmd[1]))
        if show_swap:
            if have_swap_pss:
                output_string += "\t%9s"
                output_data += (human(shared_swaps[cmd[0]]),)
            output_string += "   %9s"
            output_data += (human(swaps[cmd[0]]),)
        output_string += "\t%s\n"
        output_data += (cmd_with_count(cmd[0], count[cmd[0]]),)

        sys.stdout.write(output_string % output_data)

    if have_pss:
        if show_swap:
            if have_swap_pss:
                sys.stdout.write("%s\n%s%9s%s%9s%s%9s\n%s\n" %
                                 ("-" * 61, " " * 24, human(total), " " * 7,
                                  human(total_shared_swap), " " * 3,
                                  human(total_swap), "=" * 61))
            else:
                sys.stdout.write("%s\n%s%9s%s%9s\n%s\n" %
                                 ("-" * 45, " " * 24, human(total), " " * 3,
                                  human(total_swap), "=" * 45))
        else:
            sys.stdout.write("%s\n%s%9s\n%s\n" %
                             ("-" * 33, " " * 24, human(total), "=" * 33))


def verify_environment():
    if os.geteuid() != 0:
        sys.stderr.write("Sorry, root permission required.\n")
        sys.stderr.close()
        sys.exit(1)

    try:
        kernel_ver()
    except (IOError, OSError):
        val = sys.exc_info()[1]
        if val.errno == errno.ENOENT:
            sys.stderr.write(
              "Couldn't access " + proc.path('') + "\n"
              "Only GNU/Linux and FreeBSD (with linprocfs) are supported\n")
            sys.exit(2)
        else:
            raise

def main():
    split_args, pids_to_show, watch, only_total, discriminate_by_pid, \
    show_swap = parse_options()

    verify_environment()

    if not only_total:
        print_header(show_swap, discriminate_by_pid)

    if watch is not None:
        try:
            sorted_cmds = True
            while sorted_cmds:
                sorted_cmds, shareds, count, total, swaps, shared_swaps, \
                    total_swap, total_shared_swap = \
                    get_memory_usage(pids_to_show, split_args,
                                     discriminate_by_pid)
                if only_total and have_pss:
                    sys.stdout.write(human(total, units=1)+'\n')
                elif not only_total:
                    print_memory_usage(sorted_cmds, shareds, count, total,
                                       swaps, total_swap, shared_swaps,
                                       total_shared_swap, show_swap)

                sys.stdout.flush()
                time.sleep(watch)
            else:
                sys.stdout.write('Process does not exist anymore.\n')
        except KeyboardInterrupt:
            pass
    else:
        # This is the default behavior
        sorted_cmds, shareds, count, total, swaps, shared_swaps, total_swap, \
            total_shared_swap = get_memory_usage(pids_to_show, split_args,
                                                 discriminate_by_pid)
        if only_total and have_pss:
            sys.stdout.write(human(total, units=1)+'\n')
        elif not only_total:
            print_memory_usage(sorted_cmds, shareds, count, total, swaps,
                               total_swap, shared_swaps, total_shared_swap,
                               show_swap)

    # We must close explicitly, so that any EPIPE exception
    # is handled by our excepthook, rather than the default
    # one which is reenabled after this script finishes.
    sys.stdout.close()

    vm_accuracy = shared_val_accuracy()
    show_shared_val_accuracy( vm_accuracy, only_total )

if __name__ == '__main__': main()
                                                                                                                                                                                                                                                                              user-delete-pptp                                                                                    0000644 0000000 0000000 00000001603 13216134012 012667  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
read -p "Masukkan Username yang ingin anda hapus: " username
grep -E "^$username" /etc/ppp/chap-secrets >/dev/null
if [ $? -eq 0 ]; then
# proses mengganti passwordnya
username2="/$username/d";
sed -i $username2 /etc/ppp/chap-secrets
sed -i $username2 /var/lib/premium-script/data-user-pptp
sed -i '/^$/d' /etc/ppp/chap-secrets
sed -i '/^$/d' /var/lib/premium-script/data-user-pptp
clear
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "-----------------------------------------------"
  echo -e "Username ${blue}$username${NC} Sudah berhasil di ${red}HAPUS${NC}."
  echo -e "Akses Login untuk username ${blue}$username${NC} sudah dihapus"
  echo "-----------------------------------------------"
else
echo "Username tidak ditemukan di server anda"
    exit 1
fi                                                                                                                             user-password                                                                                       0000644 0000000 0000000 00000001631 13216134012 012307  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
read -p "Masukkan Username Yang Diganti Passwordnya: " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
read -p "Masukkan Password baru untuk user $username: " password

clear
echo "Connecting to Kang Wahid..."
sleep 0.5
echo "Merubah Password..."
sleep 0.5
  egrep "^$username" /etc/passwd >/dev/null
  echo -e "$password\n$password" | passwd $username
  clear
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "---------------------------------------"
  echo -e "Password untuk user ${blue}$username${NC} Sudah berhasil di ganti."
  echo -e "Password baru untuk user ${blue}$username${NC} adalah ${red}$password${NC}"
  echo "--------------------------------------"
  echo " "

else
echo -e "Username ${red}$username${NC} tidak ditemukan di VPS anda"
exit 0
fi                                                                                                       edit-port-dropbear                                                                                  0000644 0000000 0000000 00000011551 13133476556 013222  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
#Cek Curl
if [ ! -e /usr/bin/curl ]; then
	if [[ "$OS" = 'debian' ]]; then
	apt-get -y update && apt-get -y install curl
	else
	yum -y update && yum -y install curl
	fi
fi

CEK=`curl -s http://anonsecid.unaux.com/auth.php`;
if [ "$CEK" != "MEMBER" ]; then
		echo -e "${red}Permission Denied!${NC}";
        echo $CEK;
        exit 0;
else
echo -e "${green}Permission Accepted...${NC}"
sleep 0.6
clear
fi

#Cek ROOT
if [[ $USER != "root" ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

#Cek OS
if [[ -e /etc/debian_version ]]; then
	OS=debian
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
else
	echo "Sepertinya Anda tidak menjalankan script ini pada sistem Debian, Ubuntu atau CentOS"
	exit
fi

#Remove Temporary Files
rm -f /root/dropbearport

if [[ "$OS" = 'debian' ]]; then
	read -p "Masukkan Port Dropbear yang dipisahkan dengan 'spasi': " port
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort Dropbear sebelum diedit:\e[0m"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		echo "Port $line"
		#sed "s/Port $line//g" -i /etc/default/dropbear
	done
	rm -f /root/dropbearport

	sed '/DROPBEAR_PORT/d' -i /etc/default/dropbear
	sed '/DROPBEAR_EXTRA_ARGS/d' -i /etc/default/dropbear

	echo ""

	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -n "-p $i " >> /root/dropbearport
				echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
			fi
			
			netstat -nlpt | grep -i sshd | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenSSH\e[0m"
			fi
			
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Squid\e[0m"
			fi
			
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenVPN\e[0m"
			fi
		else
			echo -n "-p $i " >> /root/dropbearport
			echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
		fi
	done

	DROPBEAR_PORT="$(cat /root/dropbearport | awk '{print $2}')"
	sed -i "5 a\DROPBEAR_PORT=$DROPBEAR_PORT" /etc/default/dropbear

	while read line
	do
		echo "Port $line"
	done < "/root/dropbearport"
	sed -i "8 a\DROPBEAR_EXTRA_ARGS=\"$line\"" /etc/default/dropbear

	echo ""
	service dropbear restart > /dev/null
	sleep 0.5
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort Dropbear sesudah diedit:\e[0m"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/dropbearport
else
	read -p "Masukkan Port Dropbear yang dipisahkan dengan 'spasi': " port
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort Dropbear sebelum diedit:\e[0m"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		echo "Port $line"
		#sed "s/Port $line//g" -i -i /etc/sysconfig/dropbear
	done
	rm -f /root/dropbearport
	sed '/OPTIONS=/d' -i /etc/sysconfig/dropbear
	echo ""

	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -n "-p $i " >> /root/dropbearport
				echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
			fi
			
			netstat -nlpt | grep -i sshd | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenSSH\e[0m"
			fi
			
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Squid\e[0m"
			fi
			
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenVPN\e[0m"
			fi
		else
			echo -n "-p $i " >> /root/dropbearport
			echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
		fi
	done

	DROPBEAR_PORT="$(cat /root/dropbearport)"
	echo "OPTIONS=\"$DROPBEAR_PORT\"" > /etc/sysconfig/dropbear
	echo ""
	service dropbear restart > /dev/null
	sleep 0.5
	dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort Dropbear sesudah diedit:\e[0m"

	cat > /root/dropbearport <<-END
	$dropbearport
	END

	exec</root/dropbearport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/dropbearport
fi
cd                                                                                                                                                       readme.md                                                                                           0000644 0000000 0000000 00000000001 13117452704 011326  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               user-detail                                                                                         0000644 0000000 0000000 00000003302 13216134167 011717  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
if [ "$1" = "" ]
then
        echo
        echo "Cara menggunakan: $1 Username"
        echo "Contoh:  $1 budi"
        echo
        exit 1
fi

Username=`cat /etc/passwd | grep -Ew ^$1 | cut -d":" -f1`

if [ "$Username" = "" ]
then
        echo "Username $1 Tidak dapat ditemukan"
        exit 2
fi

Userid=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f3`
UserPrimaryGroupId=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f4`
UserPrimaryGroup=`cat /etc/group | grep :"$UserPrimaryGroupId": | cut -d":" -f1`
UserInfo=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f5`
UserHomeDir=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f6`
UserShell=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f7`
UserGroups=`groups $Username | awk -F": " '{print $2}'`
PasswordExpiryDate=`chage -l $Username | grep "Password expires" | awk -F": " '{print $2}'`
LastPasswordChangeDate=`chage -l $Username | grep "Last password change" | awk -F": " '{print $2}'`
AccountExpiryDate=`chage -l $Username | grep "Account expires" | awk -F": " '{print $2}'`
HomeDirSize=`du -hs $UserHomeDir | awk '{print $1}'`
clear
echo
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "Detail Account untuk username $Username"
  echo "---------------------------------------"
printf "%-25s : %5s  [User Id - %s]\n" "Username                 " "$Username" "$Userid"
printf "%-25s : %5s\n"                 "Password terakhir diganti" "$LastPasswordChangeDate"
printf "%-25s : %5s\n"                 "Account Expired Pada     " "$AccountExpiryDate"
  echo "--------------------------------------"
  echo " "

echo                                                                                                                                                                                                                                                                                                                              user-unban                                                                                          0000644 0000000 0000000 00000001321 13216134012 011544  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
read -p "Masukkan Username yang ingin anda unban: " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
# proses mengganti passwordnya
passwd -u $username
clear
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "-----------------------------------------------"
  echo -e "Username ${blue}$username${NC} Sudah berhasil di ${green}UNBAN${NC}."
  echo -e "Password untuk Username ${blue}$username${NC} sudah dikembalikan"
  echo "seperti semula"
  echo "-----------------------------------------------"
else
echo "Username tidak ditemukan di server anda"
    exit 1
fi                                                                                                                                                                                                                                                                                                               edit-port-openssh                                                                                   0000644 0000000 0000000 00000010350 13133476466 013077  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
#Cek ROOT
if [[ $USER != "root" ]]; then
	echo "Maaf. Anda harus menjalankan ini sebagai root"
	exit
fi

#Cek OS
if [[ -e /etc/debian_version ]]; then
	OS=debian
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
else
	echo "Sepertinya Anda tidak menjalankan script ini pada sistem Debian, Ubuntu atau CentOS"
	exit
fi

#Remove Temporary Files
rm -f /tmp/opensshport


if [[ "$OS" = 'debian' ]]; then
	cd
	read -p "Masukkan port OpenSSH yang dipisahkan dengan 'spasi': " port
	opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

	#Display & Delete Old OpenSSH Port
	echo ""
	echo -e "\e[34;1mPort OpenSSH sebelum diedit:\e[0m"
	cat > /root/opensshport <<-END
	$opensshport
	END

	exec</root/opensshport
	while read line
	do
		echo "Port $line"
		sed "/Port $line/d" -i /etc/ssh/sshd_config
	done
	rm -f /root/opensshport

	echo ""

	#Add New Port
	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i ssh | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				sed -i "4 a\Port $i" /etc/ssh/sshd_config
				echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
			fi
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Dropbear\e[0m"
			fi
			
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Squid\e[0m"
			fi
			
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenVPN\e[0m"
			fi
		else
			sed -i "4 a\Port $i" /etc/ssh/sshd_config
			echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
		fi
	done

	echo ""
	service ssh restart > /dev/null
	sleep 0.5
	#Display New Port
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort OpenSSH sesudah diedit:\e[0m"
	cat > /root/opensshport <<-END
	$opensshport
	END
	exec</root/opensshport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/opensshport
else 
#######################################################################################################################################
#Jika Centos
	cd
	read -p "Masukkan port OpenSSH yang dipisahkan dengan 'spasi': " port
	opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

	#Display & Delete Old OpenSSH Port
	echo ""
	echo -e "\e[34;1mPort OpenSSH sebelum diedit:\e[0m"
	cat > /root/opensshport <<-END
	$opensshport
	END

	exec</root/opensshport
	while read line
	do
		echo "Port $line"
		sed "/Port $line/d" -i /etc/ssh/sshd_config
	done
	rm -f /root/opensshport

	echo ""

	#Add New Port
	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i ssh | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				sed -i "12 a\Port $i" /etc/ssh/sshd_config
				echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
			fi
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Dropbear\e[0m"
			fi
			
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Squid\e[0m"
			fi
			
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenVPN\e[0m"
			fi
		else
			sed -i "12 a\Port $i" /etc/ssh/sshd_config
			echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
		fi
	done

	echo ""
	service sshd restart > /dev/null
	sleep 0.5
	#Display New Port
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort OpenSSH sesudah diedit:\e[0m"
	cat > /root/opensshport <<-END
	$opensshport
	END
	exec</root/opensshport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/opensshport
fi
cd                                                                                                                                                                                                                                                                                        speedtest                                                                                           0000644 0000000 0000000 00000132046 13117543772 011517  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright 2012-2016 Matt Martz
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

import os
import re
import csv
import sys
import math
import errno
import signal
import socket
import timeit
import datetime
import platform
import threading
import xml.parsers.expat

try:
    import gzip
    GZIP_BASE = gzip.GzipFile
except ImportError:
    gzip = None
    GZIP_BASE = object

__version__ = '1.0.4'


class FakeShutdownEvent(object):
    """Class to fake a threading.Event.isSet so that users of this module
    are not required to register their own threading.Event()
    """

    @staticmethod
    def isSet():
        "Dummy method to always return false"""
        return False


# Some global variables we use
USER_AGENT = None
SOURCE = None
SHUTDOWN_EVENT = FakeShutdownEvent()
SCHEME = 'http'
DEBUG = False

# Used for bound_interface
SOCKET_SOCKET = socket.socket

# Begin import game to handle Python 2 and Python 3
try:
    import json
except ImportError:
    try:
        import simplejson as json
    except ImportError:
        json = None

try:
    import xml.etree.cElementTree as ET
except ImportError:
    try:
        import xml.etree.ElementTree as ET
    except ImportError:
        from xml.dom import minidom as DOM
        ET = None

try:
    from urllib2 import urlopen, Request, HTTPError, URLError
except ImportError:
    from urllib.request import urlopen, Request, HTTPError, URLError

try:
    from httplib import HTTPConnection
except ImportError:
    from http.client import HTTPConnection

try:
    from httplib import HTTPSConnection
except ImportError:
    try:
        from http.client import HTTPSConnection
    except ImportError:
        HTTPSConnection = None

try:
    from Queue import Queue
except ImportError:
    from queue import Queue

try:
    from urlparse import urlparse
except ImportError:
    from urllib.parse import urlparse

try:
    from urlparse import parse_qs
except ImportError:
    try:
        from urllib.parse import parse_qs
    except ImportError:
        from cgi import parse_qs

try:
    from hashlib import md5
except ImportError:
    from md5 import md5

try:
    from argparse import ArgumentParser as ArgParser
    from argparse import SUPPRESS as ARG_SUPPRESS
    PARSER_TYPE_INT = int
    PARSER_TYPE_STR = str
except ImportError:
    from optparse import OptionParser as ArgParser
    from optparse import SUPPRESS_HELP as ARG_SUPPRESS
    PARSER_TYPE_INT = 'int'
    PARSER_TYPE_STR = 'string'

try:
    from io import StringIO, BytesIO, TextIOWrapper, FileIO
except ImportError:
    try:
        from cStringIO import StringIO
        BytesIO = None
    except ImportError:
        from StringIO import StringIO
        BytesIO = None

try:
    import __builtin__
except ImportError:
    import builtins

    class _Py3Utf8Stdout(TextIOWrapper):
        def __init__(self, **kwargs):
            buf = FileIO(sys.stdout.fileno(), 'w')
            super(_Py3Utf8Stdout, self).__init__(
                buf,
                encoding='utf8',
                errors='strict'
            )

        def write(self, s):
            super(_Py3Utf8Stdout, self).write(s)
            self.flush()

    _py3_print = getattr(builtins, 'print')
    _py3_utf8_stdout = _Py3Utf8Stdout()

    def print_(*args, **kwargs):
        kwargs['file'] = _py3_utf8_stdout
        _py3_print(*args, **kwargs)
else:
    del __builtin__

    def print_(*args, **kwargs):
        """The new-style print function for Python 2.4 and 2.5.

        Taken from https://pypi.python.org/pypi/six/

        Modified to set encoding to UTF-8 always
        """
        fp = kwargs.pop("file", sys.stdout)
        if fp is None:
            return

        def write(data):
            if not isinstance(data, basestring):
                data = str(data)
            # If the file has an encoding, encode unicode with it.
            encoding = 'utf8'  # Always trust UTF-8 for output
            if (isinstance(fp, file) and
                    isinstance(data, unicode) and
                    encoding is not None):
                errors = getattr(fp, "errors", None)
                if errors is None:
                    errors = "strict"
                data = data.encode(encoding, errors)
            fp.write(data)
        want_unicode = False
        sep = kwargs.pop("sep", None)
        if sep is not None:
            if isinstance(sep, unicode):
                want_unicode = True
            elif not isinstance(sep, str):
                raise TypeError("sep must be None or a string")
        end = kwargs.pop("end", None)
        if end is not None:
            if isinstance(end, unicode):
                want_unicode = True
            elif not isinstance(end, str):
                raise TypeError("end must be None or a string")
        if kwargs:
            raise TypeError("invalid keyword arguments to print()")
        if not want_unicode:
            for arg in args:
                if isinstance(arg, unicode):
                    want_unicode = True
                    break
        if want_unicode:
            newline = unicode("\n")
            space = unicode(" ")
        else:
            newline = "\n"
            space = " "
        if sep is None:
            sep = space
        if end is None:
            end = newline
        for i, arg in enumerate(args):
            if i:
                write(sep)
            write(arg)
        write(end)


# Exception "constants" to support Python 2 through Python 3
try:
    import ssl
    try:
        CERT_ERROR = (ssl.CertificateError,)
    except AttributeError:
        CERT_ERROR = tuple()

    HTTP_ERRORS = ((HTTPError, URLError, socket.error, ssl.SSLError) +
                   CERT_ERROR)
except ImportError:
    HTTP_ERRORS = (HTTPError, URLError, socket.error)


class SpeedtestException(Exception):
    """Base exception for this module"""


class SpeedtestCLIError(SpeedtestException):
    """Generic exception for raising errors during CLI operation"""


class SpeedtestHTTPError(SpeedtestException):
    """Base HTTP exception for this module"""


class SpeedtestConfigError(SpeedtestException):
    """Configuration provided is invalid"""


class ConfigRetrievalError(SpeedtestHTTPError):
    """Could not retrieve config.php"""


class ServersRetrievalError(SpeedtestHTTPError):
    """Could not retrieve speedtest-servers.php"""


class InvalidServerIDType(SpeedtestException):
    """Server ID used for filtering was not an integer"""


class NoMatchedServers(SpeedtestException):
    """No servers matched when filtering"""


class SpeedtestMiniConnectFailure(SpeedtestException):
    """Could not connect to the provided speedtest mini server"""


class InvalidSpeedtestMiniServer(SpeedtestException):
    """Server provided as a speedtest mini server does not actually appear
    to be a speedtest mini server
    """


class ShareResultsConnectFailure(SpeedtestException):
    """Could not connect to speedtest.net API to POST results"""


class ShareResultsSubmitFailure(SpeedtestException):
    """Unable to successfully POST results to speedtest.net API after
    connection
    """


class SpeedtestUploadTimeout(SpeedtestException):
    """testlength configuration reached during upload
    Used to ensure the upload halts when no additional data should be sent
    """


class SpeedtestBestServerFailure(SpeedtestException):
    """Unable to determine best server"""


class GzipDecodedResponse(GZIP_BASE):
    """A file-like object to decode a response encoded with the gzip
    method, as described in RFC 1952.

    Largely copied from ``xmlrpclib``/``xmlrpc.client`` and modified
    to work for py2.4-py3
    """
    def __init__(self, response):
        # response doesn't support tell() and read(), required by
        # GzipFile
        if not gzip:
            raise SpeedtestHTTPError('HTTP response body is gzip encoded, '
                                     'but gzip support is not available')
        IO = BytesIO or StringIO
        self.io = IO()
        while 1:
            chunk = response.read(1024)
            if len(chunk) == 0:
                break
            self.io.write(chunk)
        self.io.seek(0)
        gzip.GzipFile.__init__(self, mode='rb', fileobj=self.io)

    def close(self):
        try:
            gzip.GzipFile.close(self)
        finally:
            self.io.close()


def get_exception():
    """Helper function to work with py2.4-py3 for getting the current
    exception in a try/except block
    """
    return sys.exc_info()[1]


def bound_socket(*args, **kwargs):
    """Bind socket to a specified source IP address"""

    sock = SOCKET_SOCKET(*args, **kwargs)
    sock.bind((SOURCE, 0))
    return sock


def distance(origin, destination):
    """Determine distance between 2 sets of [lat,lon] in km"""

    lat1, lon1 = origin
    lat2, lon2 = destination
    radius = 6371  # km

    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = (math.sin(dlat / 2) * math.sin(dlat / 2) +
         math.cos(math.radians(lat1)) *
         math.cos(math.radians(lat2)) * math.sin(dlon / 2) *
         math.sin(dlon / 2))
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    d = radius * c

    return d


def build_user_agent():
    """Build a Mozilla/5.0 compatible User-Agent string"""

    global USER_AGENT
    if USER_AGENT:
        return USER_AGENT

    ua_tuple = (
        'Mozilla/5.0',
        '(%s; U; %s; en-us)' % (platform.system(), platform.architecture()[0]),
        'Python/%s' % platform.python_version(),
        '(KHTML, like Gecko)',
        'speedtest-cli/%s' % __version__
    )
    USER_AGENT = ' '.join(ua_tuple)
    printer(USER_AGENT, debug=True)
    return USER_AGENT


def build_request(url, data=None, headers=None, bump=''):
    """Build a urllib2 request object

    This function automatically adds a User-Agent header to all requests

    """

    if not USER_AGENT:
        build_user_agent()

    if not headers:
        headers = {}

    if url[0] == ':':
        schemed_url = '%s%s' % (SCHEME, url)
    else:
        schemed_url = url

    if '?' in url:
        delim = '&'
    else:
        delim = '?'

    # WHO YOU GONNA CALL? CACHE BUSTERS!
    final_url = '%s%sx=%s.%s' % (schemed_url, delim,
                                 int(timeit.time.time() * 1000),
                                 bump)

    headers.update({
        'User-Agent': USER_AGENT,
        'Cache-Control': 'no-cache',
    })

    printer('%s %s' % (('GET', 'POST')[bool(data)], final_url),
            debug=True)

    return Request(final_url, data=data, headers=headers)


def catch_request(request):
    """Helper function to catch common exceptions encountered when
    establishing a connection with a HTTP/HTTPS request

    """

    try:
        uh = urlopen(request)
        return uh, False
    except HTTP_ERRORS:
        e = get_exception()
        return None, e


def get_response_stream(response):
    """Helper function to return either a Gzip reader if
    ``Content-Encoding`` is ``gzip`` otherwise the response itself

    """

    try:
        getheader = response.headers.getheader
    except AttributeError:
        getheader = response.getheader

    if getheader('content-encoding') == 'gzip':
        return GzipDecodedResponse(response)

    return response


def get_attributes_by_tag_name(dom, tag_name):
    """Retrieve an attribute from an XML document and return it in a
    consistent format

    Only used with xml.dom.minidom, which is likely only to be used
    with python versions older than 2.5
    """
    elem = dom.getElementsByTagName(tag_name)[0]
    return dict(list(elem.attributes.items()))


def print_dots(current, total, start=False, end=False):
    """Built in callback function used by Thread classes for printing
    status
    """

    if SHUTDOWN_EVENT.isSet():
        return

    sys.stdout.write('.')
    if current + 1 == total and end is True:
        sys.stdout.write('\n')
    sys.stdout.flush()


def do_nothing(*args, **kwargs):
    pass


class HTTPDownloader(threading.Thread):
    """Thread class for retrieving a URL"""

    def __init__(self, i, request, start, timeout):
        threading.Thread.__init__(self)
        self.request = request
        self.result = [0]
        self.starttime = start
        self.timeout = timeout
        self.i = i

    def run(self):
        try:
            if (timeit.default_timer() - self.starttime) <= self.timeout:
                f = urlopen(self.request)
                while (not SHUTDOWN_EVENT.isSet() and
                        (timeit.default_timer() - self.starttime) <=
                        self.timeout):
                    self.result.append(len(f.read(10240)))
                    if self.result[-1] == 0:
                        break
                f.close()
        except IOError:
            pass


class HTTPUploaderData(object):
    """File like object to improve cutting off the upload once the timeout
    has been reached
    """

    def __init__(self, length, start, timeout):
        self.length = length
        self.start = start
        self.timeout = timeout

        self._data = None

        self.total = [0]

    def _create_data(self):
        chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        multiplier = int(round(int(self.length) / 36.0))
        IO = BytesIO or StringIO
        self._data = IO(
            ('content1=%s' %
             (chars * multiplier)[0:int(self.length) - 9]
             ).encode()
        )

    @property
    def data(self):
        if not self._data:
            self._create_data()
        return self._data

    def read(self, n=10240):
        if ((timeit.default_timer() - self.start) <= self.timeout and
                not SHUTDOWN_EVENT.isSet()):
            chunk = self.data.read(n)
            self.total.append(len(chunk))
            return chunk
        else:
            raise SpeedtestUploadTimeout

    def __len__(self):
        return self.length


class HTTPUploader(threading.Thread):
    """Thread class for putting a URL"""

    def __init__(self, i, request, start, size, timeout):
        threading.Thread.__init__(self)
        self.request = request
        self.request.data.start = self.starttime = start
        self.size = size
        self.result = None
        self.timeout = timeout
        self.i = i

    def run(self):
        request = self.request
        try:
            if ((timeit.default_timer() - self.starttime) <= self.timeout and
                    not SHUTDOWN_EVENT.isSet()):
                try:
                    f = urlopen(request)
                except TypeError:
                    # PY24 expects a string or buffer
                    # This also causes issues with Ctrl-C, but we will concede
                    # for the moment that Ctrl-C on PY24 isn't immediate
                    request = build_request(self.request.get_full_url(),
                                            data=request.data.read(self.size))
                    f = urlopen(request)
                f.read(11)
                f.close()
                self.result = sum(self.request.data.total)
            else:
                self.result = 0
        except (IOError, SpeedtestUploadTimeout):
            self.result = sum(self.request.data.total)


class SpeedtestResults(object):
    """Class for holding the results of a speedtest, including:

    Download speed
    Upload speed
    Ping/Latency to test server
    Data about server that the test was run against

    Additionally this class can return a result data as a dictionary or CSV,
    as well as submit a POST of the result data to the speedtest.net API
    to get a share results image link.
    """

    def __init__(self, download=0, upload=0, ping=0, server=None):
        self.download = download
        self.upload = upload
        self.ping = ping
        if server is None:
            self.server = {}
        else:
            self.server = server
        self._share = None
        self.timestamp = datetime.datetime.utcnow().isoformat()
        self.bytes_received = 0
        self.bytes_sent = 0

    def __repr__(self):
        return repr(self.dict())

    def share(self):
        """POST data to the speedtest.net API to obtain a share results
        link
        """

        if self._share:
            return self._share

        download = int(round(self.download / 1000.0, 0))
        ping = int(round(self.ping, 0))
        upload = int(round(self.upload / 1000.0, 0))

        # Build the request to send results back to speedtest.net
        # We use a list instead of a dict because the API expects parameters
        # in a certain order
        api_data = [
            'recommendedserverid=%s' % self.server['id'],
            'ping=%s' % ping,
            'screenresolution=',
            'promo=',
            'download=%s' % download,
            'screendpi=',
            'upload=%s' % upload,
            'testmethod=http',
            'hash=%s' % md5(('%s-%s-%s-%s' %
                             (ping, upload, download, '297aae72'))
                            .encode()).hexdigest(),
            'touchscreen=none',
            'startmode=pingselect',
            'accuracy=1',
            'bytesreceived=%s' % self.bytes_received,
            'bytessent=%s' % self.bytes_sent,
            'serverid=%s' % self.server['id'],
        ]

        headers = {'Referer': 'http://c.speedtest.net/flash/speedtest.swf'}
        request = build_request('://www.speedtest.net/api/api.php',
                                data='&'.join(api_data).encode(),
                                headers=headers)
        f, e = catch_request(request)
        if e:
            raise ShareResultsConnectFailure(e)

        response = f.read()
        code = f.code
        f.close()

        if int(code) != 200:
            raise ShareResultsSubmitFailure('Could not submit results to '
                                            'speedtest.net')

        qsargs = parse_qs(response.decode())
        resultid = qsargs.get('resultid')
        if not resultid or len(resultid) != 1:
            raise ShareResultsSubmitFailure('Could not submit results to '
                                            'speedtest.net')

        self._share = 'http://www.speedtest.net/result/%s.png' % resultid[0]

        return self._share

    def dict(self):
        """Return dictionary of result data"""

        return {
            'download': self.download,
            'upload': self.upload,
            'ping': self.ping,
            'server': self.server,
            'timestamp': self.timestamp,
            'bytes_sent': self.bytes_sent,
            'bytes_received': self.bytes_received,
            'share': self._share,
        }

    def csv(self, delimiter=','):
        """Return data in CSV format"""

        data = self.dict()
        out = StringIO()
        writer = csv.writer(out, delimiter=delimiter, lineterminator='')
        writer.writerow([data['server']['id'], data['server']['sponsor'],
                         data['server']['name'], data['timestamp'],
                         data['server']['d'], data['ping'], data['download'],
                         data['upload']])
        return out.getvalue()

    def json(self, pretty=False):
        """Return data in JSON format"""

        kwargs = {}
        if pretty:
            kwargs.update({
                'indent': 4,
                'sort_keys': True
            })
        return json.dumps(self.dict(), **kwargs)


class Speedtest(object):
    """Class for performing standard speedtest.net testing operations"""

    def __init__(self, config=None):
        self.config = {}
        self.get_config()
        if config is not None:
            self.config.update(config)

        self.servers = {}
        self.closest = []
        self.best = {}

        self.results = SpeedtestResults()

    def get_config(self):
        """Download the speedtest.net configuration and return only the data
        we are interested in
        """

        headers = {}
        if gzip:
            headers['Accept-Encoding'] = 'gzip'
        request = build_request('://www.speedtest.net/speedtest-config.php',
                                headers=headers)
        uh, e = catch_request(request)
        if e:
            raise ConfigRetrievalError(e)
        configxml = []

        stream = get_response_stream(uh)

        while 1:
            configxml.append(stream.read(1024))
            if len(configxml[-1]) == 0:
                break
        stream.close()
        uh.close()

        if int(uh.code) != 200:
            return None

        printer(''.encode().join(configxml), debug=True)

        try:
            root = ET.fromstring(''.encode().join(configxml))
            server_config = root.find('server-config').attrib
            download = root.find('download').attrib
            upload = root.find('upload').attrib
            # times = root.find('times').attrib
            client = root.find('client').attrib

        except AttributeError:
            root = DOM.parseString(''.join(configxml))
            server_config = get_attributes_by_tag_name(root, 'server-config')
            download = get_attributes_by_tag_name(root, 'download')
            upload = get_attributes_by_tag_name(root, 'upload')
            # times = get_attributes_by_tag_name(root, 'times')
            client = get_attributes_by_tag_name(root, 'client')

        ignore_servers = list(
            map(int, server_config['ignoreids'].split(','))
        )

        ratio = int(upload['ratio'])
        upload_max = int(upload['maxchunkcount'])
        up_sizes = [32768, 65536, 131072, 262144, 524288, 1048576, 7340032]
        sizes = {
            'upload': up_sizes[ratio - 1:],
            'download': [350, 500, 750, 1000, 1500, 2000, 2500,
                         3000, 3500, 4000]
        }

        counts = {
            'upload': int(upload_max * 2 / len(sizes['upload'])),
            'download': int(download['threadsperurl'])
        }

        threads = {
            'upload': int(upload['threads']),
            'download': int(server_config['threadcount']) * 2
        }

        length = {
            'upload': int(upload['testlength']),
            'download': int(download['testlength'])
        }

        self.config.update({
            'client': client,
            'ignore_servers': ignore_servers,
            'sizes': sizes,
            'counts': counts,
            'threads': threads,
            'length': length,
            'upload_max': upload_max
        })

        self.lat_lon = (float(client['lat']), float(client['lon']))

        return self.config

    def get_servers(self, servers=None):
        """Retrieve a the list of speedtest.net servers, optionally filtered
        to servers matching those specified in the ``servers`` argument
        """
        if servers is None:
            servers = []

        self.servers.clear()

        for i, s in enumerate(servers):
            try:
                servers[i] = int(s)
            except ValueError:
                raise InvalidServerIDType('%s is an invalid server type, must '
                                          'be int' % s)

        urls = [
            '://www.speedtest.net/speedtest-servers-static.php',
            'http://c.speedtest.net/speedtest-servers-static.php',
            '://www.speedtest.net/speedtest-servers.php',
            'http://c.speedtest.net/speedtest-servers.php',
        ]

        headers = {}
        if gzip:
            headers['Accept-Encoding'] = 'gzip'

        errors = []
        for url in urls:
            try:
                request = build_request('%s?threads=%s' %
                                        (url,
                                         self.config['threads']['download']),
                                        headers=headers)
                uh, e = catch_request(request)
                if e:
                    errors.append('%s' % e)
                    raise ServersRetrievalError

                stream = get_response_stream(uh)

                serversxml = []
                while 1:
                    serversxml.append(stream.read(1024))
                    if len(serversxml[-1]) == 0:
                        break

                stream.close()
                uh.close()

                if int(uh.code) != 200:
                    raise ServersRetrievalError

                printer(''.encode().join(serversxml), debug=True)

                try:
                    try:
                        root = ET.fromstring(''.encode().join(serversxml))
                        elements = root.getiterator('server')
                    except AttributeError:
                        root = DOM.parseString(''.join(serversxml))
                        elements = root.getElementsByTagName('server')
                except (SyntaxError, xml.parsers.expat.ExpatError):
                    raise ServersRetrievalError

                for server in elements:
                    try:
                        attrib = server.attrib
                    except AttributeError:
                        attrib = dict(list(server.attributes.items()))

                    if servers and int(attrib.get('id')) not in servers:
                        continue

                    if int(attrib.get('id')) in self.config['ignore_servers']:
                        continue

                    try:
                        d = distance(self.lat_lon,
                                     (float(attrib.get('lat')),
                                      float(attrib.get('lon'))))
                    except:
                        continue

                    attrib['d'] = d

                    try:
                        self.servers[d].append(attrib)
                    except KeyError:
                        self.servers[d] = [attrib]

                printer(''.encode().join(serversxml), debug=True)

                break

            except ServersRetrievalError:
                continue

        if servers and not self.servers:
            raise NoMatchedServers

        return self.servers

    def set_mini_server(self, server):
        """Instead of querying for a list of servers, set a link to a
        speedtest mini server
        """

        urlparts = urlparse(server)

        name, ext = os.path.splitext(urlparts[2])
        if ext:
            url = os.path.dirname(server)
        else:
            url = server

        request = build_request(url)
        uh, e = catch_request(request)
        if e:
            raise SpeedtestMiniConnectFailure('Failed to connect to %s' %
                                              server)
        else:
            text = uh.read()
            uh.close()

        extension = re.findall('upload_?[Ee]xtension: "([^"]+)"',
                               text.decode())
        if not extension:
            for ext in ['php', 'asp', 'aspx', 'jsp']:
                try:
                    f = urlopen('%s/speedtest/upload.%s' % (url, ext))
                except:
                    pass
                else:
                    data = f.read().strip().decode()
                    if (f.code == 200 and
                            len(data.splitlines()) == 1 and
                            re.match('size=[0-9]', data)):
                        extension = [ext]
                        break
        if not urlparts or not extension:
            raise InvalidSpeedtestMiniServer('Invalid Speedtest Mini Server: '
                                             '%s' % server)

        self.servers = [{
            'sponsor': 'Speedtest Mini',
            'name': urlparts[1],
            'd': 0,
            'url': '%s/speedtest/upload.%s' % (url.rstrip('/'), extension[0]),
            'latency': 0,
            'id': 0
        }]

        return self.servers

    def get_closest_servers(self, limit=5):
        """Limit servers to the closest speedtest.net servers based on
        geographic distance
        """

        if not self.servers:
            self.get_servers()

        for d in sorted(self.servers.keys()):
            for s in self.servers[d]:
                self.closest.append(s)
                if len(self.closest) == limit:
                    break
            else:
                continue
            break

        printer(self.closest, debug=True)
        return self.closest

    def get_best_server(self, servers=None):
        """Perform a speedtest.net "ping" to determine which speedtest.net
        server has the lowest latency
        """

        if not servers:
            if not self.closest:
                servers = self.get_closest_servers()
            servers = self.closest

        results = {}
        for server in servers:
            cum = []
            url = os.path.dirname(server['url'])
            urlparts = urlparse('%s/latency.txt' % url)
            printer('%s %s/latency.txt' % ('GET', url), debug=True)
            for _ in range(0, 3):
                try:
                    if urlparts[0] == 'https':
                        h = HTTPSConnection(urlparts[1])
                    else:
                        h = HTTPConnection(urlparts[1])
                    headers = {'User-Agent': USER_AGENT}
                    start = timeit.default_timer()
                    h.request("GET", urlparts[2], headers=headers)
                    r = h.getresponse()
                    total = (timeit.default_timer() - start)
                except HTTP_ERRORS:
                    e = get_exception()
                    printer('%r' % e, debug=True)
                    cum.append(3600)
                    continue

                text = r.read(9)
                if int(r.status) == 200 and text == 'test=test'.encode():
                    cum.append(total)
                else:
                    cum.append(3600)
                h.close()

            avg = round((sum(cum) / 6) * 1000.0, 3)
            results[avg] = server

        try:
            fastest = sorted(results.keys())[0]
        except IndexError:
            raise SpeedtestBestServerFailure('Unable to connect to servers to '
                                             'test latency.')
        best = results[fastest]
        best['latency'] = fastest

        self.results.ping = fastest
        self.results.server = best

        self.best.update(best)
        printer(best, debug=True)
        return best

    def download(self, callback=do_nothing):
        """Test download speed against speedtest.net"""

        urls = []
        for size in self.config['sizes']['download']:
            for _ in range(0, self.config['counts']['download']):
                urls.append('%s/random%sx%s.jpg' %
                            (os.path.dirname(self.best['url']), size, size))

        request_count = len(urls)
        requests = []
        for i, url in enumerate(urls):
            requests.append(build_request(url, bump=i))

        def producer(q, requests, request_count):
            for i, request in enumerate(requests):
                thread = HTTPDownloader(i, request, start,
                                        self.config['length']['download'])
                thread.start()
                q.put(thread, True)
                callback(i, request_count, start=True)

        finished = []

        def consumer(q, request_count):
            while len(finished) < request_count:
                thread = q.get(True)
                while thread.isAlive():
                    thread.join(timeout=0.1)
                finished.append(sum(thread.result))
                callback(thread.i, request_count, end=True)

        q = Queue(self.config['threads']['download'])
        prod_thread = threading.Thread(target=producer,
                                       args=(q, requests, request_count))
        cons_thread = threading.Thread(target=consumer,
                                       args=(q, request_count))
        start = timeit.default_timer()
        prod_thread.start()
        cons_thread.start()
        while prod_thread.isAlive():
            prod_thread.join(timeout=0.1)
        while cons_thread.isAlive():
            cons_thread.join(timeout=0.1)

        stop = timeit.default_timer()
        self.results.bytes_received = sum(finished)
        self.results.download = (
            (self.results.bytes_received / (stop - start)) * 8.0
        )
        if self.results.download > 100000:
            self.config['threads']['upload'] = 8
        return self.results.download

    def upload(self, callback=do_nothing):
        """Test upload speed against speedtest.net"""

        sizes = []

        for size in self.config['sizes']['upload']:
            for _ in range(0, self.config['counts']['upload']):
                sizes.append(size)

        # request_count = len(sizes)
        request_count = self.config['upload_max']

        requests = []
        for i, size in enumerate(sizes):
            # We set ``0`` for ``start`` and handle setting the actual
            # ``start`` in ``HTTPUploader`` to get better measurements
            requests.append(
                (
                    build_request(
                        self.best['url'],
                        HTTPUploaderData(size, 0,
                                         self.config['length']['upload'])
                    ),
                    size
                )
            )

        def producer(q, requests, request_count):
            for i, request in enumerate(requests[:request_count]):
                thread = HTTPUploader(i, request[0], start, request[1],
                                      self.config['length']['upload'])
                thread.start()
                q.put(thread, True)
                callback(i, request_count, start=True)

        finished = []

        def consumer(q, request_count):
            while len(finished) < request_count:
                thread = q.get(True)
                while thread.isAlive():
                    thread.join(timeout=0.1)
                finished.append(thread.result)
                callback(thread.i, request_count, end=True)

        q = Queue(self.config['threads']['upload'])
        prod_thread = threading.Thread(target=producer,
                                       args=(q, requests, request_count))
        cons_thread = threading.Thread(target=consumer,
                                       args=(q, request_count))
        start = timeit.default_timer()
        prod_thread.start()
        cons_thread.start()
        while prod_thread.isAlive():
            prod_thread.join(timeout=0.1)
        while cons_thread.isAlive():
            cons_thread.join(timeout=0.1)

        stop = timeit.default_timer()
        self.results.bytes_sent = sum(finished)
        self.results.upload = (
            (self.results.bytes_sent / (stop - start)) * 8.0
        )
        return self.results.upload


def ctrl_c(signum, frame):
    """Catch Ctrl-C key sequence and set a SHUTDOWN_EVENT for our threaded
    operations
    """

    SHUTDOWN_EVENT.set()
    print_('\nCancelling...')
    sys.exit(0)


def version():
    """Print the version"""

    print_(__version__)
    sys.exit(0)


def csv_header():
    """Print the CSV Headers"""

    print_('Server ID,Sponsor,Server Name,Timestamp,Distance,Ping,Download,'
           'Upload')
    sys.exit(0)


def parse_args():
    """Function to handle building and parsing of command line arguments"""
    description = (
        'Command line interface for testing internet bandwidth using '
        'speedtest.net.\n'
        '------------------------------------------------------------'
        '--------------\n'
        'https://github.com/sivel/speedtest-cli')

    parser = ArgParser(description=description)
    # Give optparse.OptionParser an `add_argument` method for
    # compatibility with argparse.ArgumentParser
    try:
        parser.add_argument = parser.add_option
    except AttributeError:
        pass
    parser.add_argument('--no-download', dest='download', default=True,
                        action='store_const', const=False,
                        help='Do not perform download test')
    parser.add_argument('--no-upload', dest='upload', default=True,
                        action='store_const', const=False,
                        help='Do not perform upload test')
    parser.add_argument('--bytes', dest='units', action='store_const',
                        const=('byte', 8), default=('bit', 1),
                        help='Display values in bytes instead of bits. Does '
                             'not affect the image generated by --share, nor '
                             'output from --json or --csv')
    parser.add_argument('--share', action='store_true',
                        help='Generate and provide a URL to the speedtest.net '
                             'share results image, not displayed with --csv')
    parser.add_argument('--simple', action='store_true', default=False,
                        help='Suppress verbose output, only show basic '
                             'information')
    parser.add_argument('--csv', action='store_true', default=False,
                        help='Suppress verbose output, only show basic '
                             'information in CSV format. Speeds listed in '
                             'bit/s and not affected by --bytes')
    parser.add_argument('--csv-delimiter', default=',', type=PARSER_TYPE_STR,
                        help='Single character delimiter to use in CSV '
                             'output. Default ","')
    parser.add_argument('--csv-header', action='store_true', default=False,
                        help='Print CSV headers')
    parser.add_argument('--json', action='store_true', default=False,
                        help='Suppress verbose output, only show basic '
                             'information in JSON format. Speeds listed in '
                             'bit/s and not affected by --bytes')
    parser.add_argument('--list', action='store_true',
                        help='Display a list of speedtest.net servers '
                             'sorted by distance')
    parser.add_argument('--server', help='Specify a server ID to test against',
                        type=PARSER_TYPE_INT)
    parser.add_argument('--mini', help='URL of the Speedtest Mini server')
    parser.add_argument('--source', help='Source IP address to bind to')
    parser.add_argument('--timeout', default=10, type=PARSER_TYPE_INT,
                        help='HTTP timeout in seconds. Default 10')
    parser.add_argument('--secure', action='store_true',
                        help='Use HTTPS instead of HTTP when communicating '
                             'with speedtest.net operated servers')
    parser.add_argument('--version', action='store_true',
                        help='Show the version number and exit')
    parser.add_argument('--debug', action='store_true',
                        help=ARG_SUPPRESS, default=ARG_SUPPRESS)

    options = parser.parse_args()
    if isinstance(options, tuple):
        args = options[0]
    else:
        args = options
    return args


def validate_optional_args(args):
    """Check if an argument was provided that depends on a module that may
    not be part of the Python standard library.

    If such an argument is supplied, and the module does not exist, exit
    with an error stating which module is missing.
    """
    optional_args = {
        'json': ('json/simplejson python module', json),
        'secure': ('SSL support', HTTPSConnection),
    }

    for arg, info in optional_args.items():
        if getattr(args, arg, False) and info[1] is None:
            raise SystemExit('%s is not installed. --%s is '
                             'unavailable' % (info[0], arg))


def printer(string, quiet=False, debug=False, **kwargs):
    """Helper function to print a string only when not quiet"""

    if debug and not DEBUG:
        return

    if debug:
        out = '\033[1;30mDEBUG: %s\033[0m' % string
    else:
        out = string

    if not quiet:
        print_(out, **kwargs)


def shell():
    """Run the full speedtest.net test"""

    global SHUTDOWN_EVENT, SOURCE, SCHEME, DEBUG
    SHUTDOWN_EVENT = threading.Event()

    signal.signal(signal.SIGINT, ctrl_c)

    args = parse_args()

    # Print the version and exit
    if args.version:
        version()

    if not args.download and not args.upload:
        raise SpeedtestCLIError('Cannot supply both --no-download and '
                                '--no-upload')

    if args.csv_header:
        csv_header()

    if len(args.csv_delimiter) != 1:
        raise SpeedtestCLIError('--csv-delimiter must be a single character')

    validate_optional_args(args)

    socket.setdefaulttimeout(args.timeout)

    # If specified bind to a specific IP address
    if args.source:
        SOURCE = args.source
        socket.socket = bound_socket

    if args.secure:
        SCHEME = 'https'

    debug = getattr(args, 'debug', False)
    if debug == 'SUPPRESSHELP':
        debug = False
    if debug:
        DEBUG = True

    # Pre-cache the user agent string
    build_user_agent()

    if args.simple or args.csv or args.json:
        quiet = True
    else:
        quiet = False

    if args.csv or args.json:
        machine_format = True
    else:
        machine_format = False

    # Don't set a callback if we are running quietly
    if quiet or debug:
        callback = do_nothing
    else:
        callback = print_dots

    printer('Retrieving speedtest.net configuration...', quiet)
    try:
        speedtest = Speedtest()
    except (ConfigRetrievalError, HTTP_ERRORS):
        printer('Cannot retrieve speedtest configuration')
        raise SpeedtestCLIError(get_exception())

    if args.list:
        try:
            speedtest.get_servers()
        except (ServersRetrievalError, HTTP_ERRORS):
            print_('Cannot retrieve speedtest server list')
            raise SpeedtestCLIError(get_exception())

        for _, servers in sorted(speedtest.servers.items()):
            for server in servers:
                line = ('%(id)5s) %(sponsor)s (%(name)s, %(country)s) '
                        '[%(d)0.2f km]' % server)
                try:
                    print_(line)
                except IOError:
                    e = get_exception()
                    if e.errno != errno.EPIPE:
                        raise
        sys.exit(0)

    # Set a filter of servers to retrieve
    servers = []
    if args.server:
        servers.append(args.server)

    printer('Testing from %(isp)s (%(ip)s)...' % speedtest.config['client'],
            quiet)

    if not args.mini:
        printer('Retrieving speedtest.net server list...', quiet)
        try:
            speedtest.get_servers(servers)
        except NoMatchedServers:
            raise SpeedtestCLIError('No matched servers: %s' % args.server)
        except (ServersRetrievalError, HTTP_ERRORS):
            print_('Cannot retrieve speedtest server list')
            raise SpeedtestCLIError(get_exception())
        except InvalidServerIDType:
            raise SpeedtestCLIError('%s is an invalid server type, must '
                                    'be an int' % args.server)

        printer('Selecting best server based on ping...', quiet)
        speedtest.get_best_server()
    elif args.mini:
        speedtest.get_best_server(speedtest.set_mini_server(args.mini))

    results = speedtest.results

    printer('Hosted by %(sponsor)s (%(name)s) [%(d)0.2f km]: '
            '%(latency)s ms' % results.server, quiet)

    if args.download:
        printer('Testing download speed', quiet,
                end=('', '\n')[bool(debug)])
        speedtest.download(callback=callback)
        printer('Download: %0.2f M%s/s' %
                ((results.download / 1000.0 / 1000.0) / args.units[1],
                 args.units[0]),
                quiet)
    else:
        printer('Skipping download test')

    if args.upload:
        printer('Testing upload speed', quiet,
                end=('', '\n')[bool(debug)])
        speedtest.upload(callback=callback)
        printer('Upload: %0.2f M%s/s' %
                ((results.upload / 1000.0 / 1000.0) / args.units[1],
                 args.units[0]),
                quiet)
    else:
        printer('Skipping upload test')

    if args.simple:
        print_('Ping: %s ms\nDownload: %0.2f M%s/s\nUpload: %0.2f M%s/s' %
               (results.ping,
                (results.download / 1000.0 / 1000.0) / args.units[1],
                args.units[0],
                (results.upload / 1000.0 / 1000.0) / args.units[1],
                args.units[0]))
    elif args.csv:
        print_(results.csv(delimiter=args.csv_delimiter))
    elif args.json:
        if args.share:
            results.share()
        print_(results.json())

    if args.share and not machine_format:
        printer('Share results: %s' % results.share())


def main():
    try:
        shell()
    except KeyboardInterrupt:
        print_('\nCancelling...')
    except (SpeedtestException, SystemExit):
        e = get_exception()
        if getattr(e, 'code', 1) != 0:
            raise SystemExit('ERROR: %s' % e)


if __name__ == '__main__':
    main()

# vim:ts=4:sw=4:expandtab
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          user-detail-pptp                                                                                    0000644 0000000 0000000 00000002130 13216134012 012663  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
chmod +x /var/lib/premium-script/data-user-pptp


read -p "Masukkan Username : " username
grep -E "^$username" /var/lib/premium-script/data-user-pptp >/dev/null
if [ $? -eq 0 ]; then
userpass=`cat /var/lib/premium-script/data-user-pptp | grep "^$username" | awk '{print $3}'`
saat_expired=`cat /var/lib/premium-script/data-user-pptp | grep "^$username" | awk '{print $5}'`
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')
clear
echo "loading..."
sleep 1
clear
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "Demikian Detail Account Untuk Username $Username"
  echo "---------------------------------------"
  echo "   Username        : $username"
  echo "   Password        : $userpass"
  echo "   Tanggal Expired : $tanggal_expired_display"
  echo "--------------------------------------"
else
echo "Username tidak ditemukan di server anda"
    exit 1
fi                                                                                                                                                                                                                                                                                                                                                                                                                                        user-unlock                                                                                         0000644 0000000 0000000 00000001327 13216134012 011742  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
read -p "Masukkan Username yang ingin anda unlock: " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
# proses mengganti passwordnya
passwd -u $username
clear
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "-----------------------------------------------"
  echo -e "Username ${blue}$username${NC} Sudah berhasil di ${green}BUKA KUNCINYA${NC}."
  echo -e "Akses untuk Username ${blue}$username${NC} sudah dikembalikan"
  echo "seperti semula"
  echo "-----------------------------------------------"
else
echo "Username tidak ditemukan di server anda"
    exit 1
fi                                                                                                                                                                                                                                                                                                         edit-port-openvpn                                                                                   0000644 0000000 0000000 00000010206 13133476575 013106  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
#Cek Curl
if [ ! -e /usr/bin/curl ]; then
	if [[ "$OS" = 'debian' ]]; then
	apt-get -y update && apt-get -y install curl
	else
	yum -y update && yum -y install curl
	fi
fi

#Cek ROOT
if [[ $USER != "root" ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

#Cek OS
if [[ -e /etc/debian_version ]]; then
	OS=debian
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
else
	echo "Sepertinya Anda tidak menjalankan script ini pada sistem Debian, Ubuntu atau CentOS"
	exit
fi

#Remove Temporary Files
rm -f /root/openvpnport

if [[ "$OS" = 'debian' ]]; then
	read -p "Masukkan port OpenVPN yang diinginkan: " port

	openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort OpenVPN sebelum diedit:\e[0m"

	cat > /root/openvpnport <<-END
	$openvpnport
	END

	exec</root/openvpnport
	while read line
	do
		echo "Port $line"
		sed "/port $line/d" -i /etc/openvpn/server.conf
	done
	rm -f /root/openvpnport

	echo ""

	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				sed -i "1 a\port $i" /etc/openvpn/server.conf
				echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
			fi
			
			netstat -nlpt | grep -i ssh | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenSSH\e[0m"
			fi
			
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Dropbear\e[0m"
			fi
			
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Squid\e[0m"
			fi
		else
			sed -i "1 a\port $i" /etc/openvpn/server.conf
			echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
		fi
	done

	echo ""
	service openvpn restart > /dev/null
	sleep 0.5
	rm -f /root/openvpnport
	openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort OpenVPN sesudah diedit:\e[0m"

	cat > /root/openvpnport <<-END
	$openvpnport
	END

	exec</root/openvpnport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/openvpnport
else
	read -p "Masukkan port OpenVPN yang diinginkan: " port

	openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort OpenVPN sebelum diedit:\e[0m"

	cat > /root/openvpnport <<-END
	$openvpnport
	END

	exec</root/openvpnport
	while read line
	do
		echo "Port $line"
		sed "/port $line/d" -i /etc/openvpn/server.conf
	done
	rm -f /root/openvpnport

	echo ""

	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				sed -i "1 a\port $i" /etc/openvpn/server.conf
				echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
			fi
			
			netstat -nlpt | grep -i ssh | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenSSH\e[0m"
			fi
			
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Dropbear\e[0m"
			fi
			
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Squid\e[0m"
			fi
		else
			sed -i "1 a\port $i" /etc/openvpn/server.conf
			echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
		fi
	done

	echo ""
	service openvpn restart > /dev/null
	sleep 0.5
	rm -f /root/openvpnport
	openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort OpenVPN sesudah diedit:\e[0m"

	cat > /root/openvpnport <<-END
	$openvpnport
	END

	exec</root/openvpnport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/openvpnport
fi
cd                                                                                                                                                                                                                                                                                                                                                                                          trial                                                                                               0000644 0000000 0000000 00000003024 13216135157 010615  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
clear
echo "Please Wait..."
sleep 0.5
echo "Generating Account..."
sleep 0.5
echo "Generating Host..."
sleep 0.5
echo "Generating Username..."
sleep 0.5
echo "Generating Password..."
sleep 1
MYIP=$(wget -qO- ipv4.icanhazip.com)
passrandom=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

username=trial
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
# proses mengganti passwordnya
  echo -e "$passrandom\n$passrandom" | passwd $username
  clear
  echo " "
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "Demikian Detail Account Trial Anda"
  echo "------------------------------"
  echo "   Host     : $MYIP" 
  echo "   Username : $username"
  echo "   Password : $passrandom"
  echo "   Port     : 22,80,109,143,443"
  echo "------------------------------"
  echo " "
  
else
  useradd trial
  usermod -s /bin/false trial
  egrep "^$username" /etc/passwd >/dev/null
  echo -e "$passrandom\n$passrandom" | passwd $username
  clear
  echo " "
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "Demikian Detail Account Trial Anda"
  echo "------------------------------"
  echo "   Host     : $MYIP"
  echo "   Username : $username"
  echo "   Password : $passrandom"
  echo "   Port     : 22,80,109,143,443"
  echo "------------------------------"
  echo " "
fi                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            user-expire                                                                                         0000644 0000000 0000000 00000003301 13216357415 011753  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
echo "echo "Script Created By BYVPN.NET"" > /usr/local/bin/infouser
echo "echo "Script Created By BYVPN.NET"" > /usr/local/bin/expireduser
echo "echo "Script Created By BYVPN.NET"" > /usr/local/bin/alluser
chmod +x /usr/local/bin/infouser
chmod +x /usr/local/bin/expireduser
chmod +x /usr/local/bin/alluser

cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
       do
       tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
       username=`echo $tuserval | cut -f1 -d:`
       userexp=`echo $tuserval | cut -f2 -d:`
       userexpireinseconds=$(( $userexp * 86400 ))
       tglexp=`date -d @$userexpireinseconds`             
       tgl=`echo $tglexp |awk -F" " '{print $3}'`
       while [ ${#tgl} -lt 2 ]
       do
           tgl="0"$tgl
       done
       while [ ${#username} -lt 15 ]
       do
           username=$username" " 
       done
       bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
       echo "echo "BYVPN.NET- User : $username Expire Pada Tanggal : $tgl $bulantahun"" >> /usr/local/bin/alluser
       todaystime=`date +%s`
       if [ $userexpireinseconds -ge $todaystime ] ;
           then
           timeto7days=$(( $todaystime + 604800 ))
                if [ $userexpireinseconds -le $timeto7days ];
                then                     
                     echo "echo "BYVPN.NET- User : $username Akan Segera Expired Pada tanggal : $tgl $bulantahun"" >> /usr/local/bin/infouser
                fi
       else
       echo "echo "BYVPN.NET- User : $username Sudah Expired Pada Tanggal : $tgl $bulantahun"" >> /usr/local/bin/expireduser
       passwd -l $username
       fi
done                                                                                                                                                                                                                                                                                                                               edit-port-squid                                                                                     0000644 0000000 0000000 00000010307 13133476606 012543  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
#Cek Curl
if [ ! -e /usr/bin/curl ]; then
	if [[ "$OS" = 'debian' ]]; then
	apt-get -y update && apt-get -y install curl
	else
	yum -y update && yum -y install curl
	fi
fi

#Cek ROOT
if [[ $USER != "root" ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

#Cek OS
if [[ -e /etc/debian_version ]]; then
	OS=debian
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
else
	echo "Sepertinya Anda tidak menjalankan script ini pada sistem Debian, Ubuntu atau CentOS"
	exit
fi

#Remove Temporary Files
rm -f /root/squidport

if [[ "$OS" = 'debian' ]]; then
	read -p "Masukkan port Squid yang dipisahkan dengan 'spasi': " port
	squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"
	echo ""
	echo -e "\e[34;1mPort Squid sebelum diedit:\e[0m"

	cat > /root/squidport <<-END
	$squidport
	END

	exec</root/squidport
	while read line
	do
		echo "Port $line"
		sed "/http_port $line/d" -i /etc/squid3/squid.conf
		#sed "s/Port $line//g" -i /etc/squid3/squid.conf
	done
	rm -f /root/squidport

	echo ""

	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				sed -i "21 a\http_port $i" /etc/squid3/squid.conf
				echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
			fi
			
			netstat -nlpt | grep -i ssh | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenSSH\e[0m"
			fi
			
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Dropbear\e[0m"
			fi
			
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenVPN\e[0m"
			fi
		else
			sed -i "21 a\http_port $i" /etc/squid3/squid.conf
			echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
		fi
	done

	echo ""
	echo "Mohon Tunggu..."
	echo ""
	service squid3 restart > /dev/null
	sleep 0.5
	rm -f /root/squidport
	squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"
	echo -e "\e[34;1mPort Squid sesudah diedit:\e[0m"

	cat > /root/squidport <<-END
	$squidport
	END

	exec</root/squidport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/squidport
else
	read -p "Masukkan port Squid yang dipisahkan dengan 'spasi': " port
	squidport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}')"
	echo ""
	echo -e "\e[34;1mPort Squid sebelum diedit:\e[0m"
	cat > /root/squidport <<-END
	$squidport
	END
	exec</root/squidport
	while read line
	do
		echo "Port $line"
		sed "/http_port $line/d" -i /etc/squid/squid.conf
		#sed "s/Port $line//g" -i /etc/squid/squid.conf
	done
	rm -f /root/squidport
	echo ""
	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				sed -i "27 a\http_port $i" /etc/squid/squid.conf
				echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
			fi
			
			netstat -nlpt | grep -i ssh | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenSSH\e[0m"
			fi
			
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk Dropbear\e[0m"
			fi
			
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i gagal ditambahkan. Port $i sudah digunakan untuk OpenVPN\e[0m"
			fi
		else
			sed -i "27 a\http_port $i" /etc/squid/squid.conf
			echo -e "\e[032;1mPort $i berhasil ditambahkan\e[0m"
		fi
	done
	echo ""
	echo "Mohon Tunggu..."
	echo ""
	service squid restart > /dev/null
	sleep 0.5
	rm -f /root/squidport
	squidport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}')"
	echo -e "\e[34;1mPort Squid sesudah diedit:\e[0m"

	cat > /root/squidport <<-END
	$squidport
	END

	exec</root/squidport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/squidport
fi
cd
                                                                                                                                                                                                                                                                                                                         user-add                                                                                            0000644 0000000 0000000 00000004152 13216311256 011205  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
read -p " [+] ใส่ชื่อผู้ใช้งาน : " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
echo " [+] มีผู้ใช้นี้แล้ว"
exit 0
else
read -p " [+] ใส่รหัสผ่าน : " password
read -p " [+] ใส่วันใช้งาน (30) : " masa_aktif
MYIP=$(wget -qO- ipv4.icanhazip.com)
today=`date +%s`
masa_aktif_detik=$(( $masa_aktif * 86400 ))
saat_expired=$(($today + $masa_aktif_detik))
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')
clear
echo "กำลังเชื่อมต่ออยู่ byvpn.net..."
sleep 0.4
echo "การสร้างบัญชี..."
sleep 0.3
echo "กำลังสร้างโฮสต์..."
sleep 0.2
echo "การสร้างชื่อผู้ใช้ใหม่ของคุณ : $username"
sleep 0.2
echo "การสร้างรหัสผ่านสำหรับ : $username"
sleep 1


useradd $username
usermod -s /bin/false $username
usermod -e  $tanggal_expired $username
  egrep "^$username" /etc/passwd >/dev/null
  echo -e "$password\n$password" | passwd $username
  clear
  echo " "
  echo  "------------ พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) ------------" 
  echo " "
  echo  " [+]  ไอพี         : $MYIP"
  echo  " [+]  ชื่อผู้ใช้     : $username"
  echo  " [+]  รหัสผ่าน    : $password"
  echo  " [+]  ใช้งานได้   : $masa_aktif วัน"
  echo  " [+]  หมดอายุวันที่ : $tanggal_expired_display"
  echo  " [+]  OpenVPN    : 1194 "
  echo  " [+]  PPTPVPN    : 1732"
  echo  " [+]  OpenSSH    : 22,143"
  echo  " [+]  DropBear    : 109,110,443"
  echo  " [+]  SquidProxy   : 80,3128,8000,8080"
  echo  " [+]  Ovpn          : http://$MYIP:81/client.ovpn "
  echo " "
  echo  "------------ พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) ------------" 
  echo " "
fi
                                                                                                                                                                                                                                                                                                                                                                                                                      user-expire-pptp                                                                                    0000644 0000000 0000000 00000007411 13216357415 012742  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
echo "echo "Script Created By BYVPN.NET"" > /usr/local/bin/infouser-pptp
echo "echo "Script Created By BYVPN.NET"" > /usr/local/bin/expireduser-pptp
chmod +x /usr/local/bin/infouser-pptp
chmod +x /usr/local/bin/expireduser
chmod +x /etc/ppp/chap-secrets
chmod +x /var/lib/premium-script/data-user-pptp

totalaccounts=`cat /var/lib/premium-script/data-user-pptp | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
       do       
       username=`cat /var/lib/premium-script/data-user-pptp | awk '{print $1}' | head -n $i | tail -n 1`
       userexpireinseconds=`cat /var/lib/premium-script/data-user-pptp | awk '{print $5}' | head -n $i | tail -n 1`
       tglexp=`date -d @$userexpireinseconds`             
       tgl=`echo $tglexp|awk -F" " '{print $3}'`
       bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
       todaystime=`date +%s`
	   seeder=s/^$username/#$username/g
       if [ $userexpireinseconds -ge $todaystime ] ;
           then
           timeto7days=$(( $todaystime + 604800 ))
                if [ $userexpireinseconds -le $timeto7days ];
                then                     
                     echo "echo "BYVPN.NET- User : $username Akan Segera Expired Pada tanggal : $tgl $bulantahun"" >> /usr/local/bin/infouser-pptp
                fi
       else
       echo "echo "BYVPN.NET- User : $username Sudah Expired Pada Tanggal : $tgl $bulantahun"" >> /usr/local/bin/expireduser-pptp
	   sed -i $seeder /var/lib/premium-script/data-user-pptp
	   sed -i $seeder /etc/ppp/chap-secrets
	   sed -i "s|##|#|g" /etc/ppp/chap-secrets
	   sed -i "s|###|#|g" /etc/ppp/chap-secrets
	   sed -i "s|####|#|g" /etc/ppp/chap-secrets
	   sed -i "s|#####|#|g" /etc/ppp/chap-secrets
	   sed -i "s|######|#|g" /etc/ppp/chap-secrets
	   sed -i "s|#######|#|g" /etc/ppp/chap-secrets
	   sed -i "s|########|#|g" /etc/ppp/chap-secrets
	   sed -i "s|#########|#|g" /etc/ppp/chap-secrets
	   sed -i "s|##########|#|g" /etc/ppp/chap-secrets
	   sed -i "s|###########|#|g" /etc/ppp/chap-secrets
	   sed -i "s|############|#|g" /etc/ppp/chap-secrets
	   sed -i "s|#############|#|g" /etc/ppp/chap-secrets
	   sed -i "s|##############|#|g" /etc/ppp/chap-secrets
	   sed -i "s|###############|#|g" /etc/ppp/chap-secrets
	   sed -i "s|################|#|g" /etc/ppp/chap-secrets
	   sed -i "s|#################|#|g" /etc/ppp/chap-secrets
	   sed -i "s|##|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|###|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|####|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|#####|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|######|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|#######|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|########|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|#########|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|##########|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|###########|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|############|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|#############|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|##############|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|###############|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|################|#|g" /var/lib/premium-script/data-user-pptp
	   sed -i "s|#################|#|g" /var/lib/premium-script/data-user-pptp
       fi
done
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
    echo "-----------------------------------------------"
  echo -e "User VPN PPTP yang telah expired telah dikunci"
  echo -e "Akses Login untuk username sudah dikunci"
  echo "-----------------------------------------------"                                                                                                                                                                                                                                                       limit.sh                                                                                            0000644 0000000 0000000 00000000047 13117543772 011241  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
#/usr/local/bin/user-limit
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         user-add-pptp                                                                                       0000644 0000000 0000000 00000003064 13216134012 012160  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
if [ -e "/var/lib/premium-script" ]; then
		echo "continue..."
		clear
	else
		mkdir /var/lib/premium-script;
fi
read -p "Masukkan Username : " username
grep -E "^$username" /etc/ppp/chap-secrets >/dev/null
if [ $? -eq 0 ]; then
echo "Username sudah ada di VPS anda"
exit 0
else
read -p "Masukkan Password : " password
read -p "Masukkan Lama Masa Aktif Account(Hari): " masa_aktif

today=`date +%s`
masa_aktif_detik=$(( $masa_aktif * 86400 ))
saat_expired=$(($today + $masa_aktif_detik))
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')
clear
echo "Connecting to Kang wahid..."
sleep 0.5
echo "Creating Account..."
sleep 0.2
echo "Generating Host..."
sleep 0.2
echo "Creating Your New Username: $username"
sleep 0.2
echo "Creating Password for $username"
sleep 0.3
MYIP=$(wget -qO- ipv4.icanhazip.com)
echo "$username	*	$password	*" >> /etc/ppp/chap-secrets
echo "$username *   $password   *  $saat_expired"  >> /var/lib/premium-script/data-user-pptp
  clear
  echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
  echo " "
  echo " "
  echo "Demikian Detail Account Yang Telah Dibuat"
  echo "---------------------------------------"
  echo "   Host            : $MYIP"
  echo "   Username        : $username"
  echo "   Password        : $password"
  echo "   Tanggal Expired : $tanggal_expired_display"
  echo "--------------------------------------"
  echo " "
fi                                                                                                                                                                                                                                                                                                                                                                                                                                                                            user-generate                                                                                       0000644 0000000 0000000 00000002514 13216360054 012247  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
IP=$(wget -qO- ipv4.icanhazip.com)
read -p " [+] จำนวนบัญชีจะถูกสร้างขึ้น: " banyakuser
read -p " [+] ป้อนอายุการใช้งานที่ใช้งานของบัญชี (วัน): " aktif
today="$(date +"%Y-%m-%d")"
expire=$(date -d "$aktif days" +"%Y-%m-%d")
clear
echo "----------------------- พัฒนาโดย คุณเต้ ทารุมะ (เต้เล็ก) -----------------------"
echo " [+] รายละเอียดบัญชี"
echo "----------------------------------"
echo " [+] Host/IP: $IP"
echo " [+] Port OpenSSH: 22,143"
echo " [+] Port Dropbear: 443,110,109"
echo " [+] Port Squid Proxy: 80,3128,8000,8080"
echo " [+] OpenVPN Config: http://$IP:81/client.ovpn"
echo " [+] ใช้งานได้ถึงวันที่: $(date -d "$aktif วัน" +"%d-%m-%Y")"
  echo "----------------------------------"
for (( i=1; i <= $banyakuser; i++ ))
do
	USER=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`
	useradd -M -N -s /bin/false -e $expire $USER
	PASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`;
	echo $USER:$USER | chpasswd
	echo "$i. Username และ Password เหมือนกัน: $USER"
done

  echo "--------------------------------------"
  echo " "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    