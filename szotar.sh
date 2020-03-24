#!/bin/bash
# ez a program a vágólapra másolt szóhoz fordítást vár, 
# majd a szópárokat beleteszi egy fájlba

#### this programs you nedd to be installed on your computer
#### sudo apt install xclip
#### sudo apt install trans-shell

#if [[ -n "$(type xclip 2>/dev/null)" ]]; then
#    echo "van ilyen ilyen progi";
#else
#    echo "telepítened kell az xclip programot:";
#    echo 'sudo apt install xclip'
#    sudo apt install xclip
#fi

clear
green=$(tput setaf 2; tput bold)
red=$(tput setaf 1; tput bold)
white=$(tput setaf 7; tput bold)
none=$(tput sgr0)
ut="/home/$USER/bin/"
# ha nincs fájl az elérésen akkor hozd létre
[ -f ${ut}szavak.txt ] || touch ${ut}szavak.txt
file=${ut}szavak.txt
printf "\n\t"

# ha ürs a vágólap, és nincs paraméter sem, akkor kérje be: $szo
while true; do
    clear
    # Ha se vágólap se paratméter
    if [ $(xclip -se c -o | wc -m) -lt 2 ] && [[ $# -lt 1 ]]; then
        echo -e "\tNincs paraméter és a vágólap is üres."
        printf "\n\tÍrd be, vagy másold vágólapra a fordítandó szót:\n\t"
        echo -e "${green}ENTER${none} ha bemásoltad"
        # kérjen be egy paramétert
        read alibi
            if [[ $(xclip -se c -o | wc -m) -gt 2 ]]; then
                szo=$(xclip -se c -o)
                echo -e "Ez lenne az?:${green}$szo${none}"
                echo -e "${green}ENTER${none} ha igen"
                read alibi
                break
            else
                clear
                printf "\n\tÍrd be, vagy másold vágólapra a fordítandó szót:\n\t"
                echo -e "${green}ENTER${none} ha bemásoltad"
                read alibi
                echo -e "\tÍrd be a fordítandó szót:"
                read szo
                if [[ $(echo $szo | wc) -gt 2 ]]; then
                    echo $szo
                    break
                fi
                    break
            fi

        echo -e "${green}$szo${none}"
        read varj
    # ha van már a vágólapon valami
    elif [ $(xclip -se c -o | wc -m) -gt 2 ] && [[ $# -lt 1 ]]; then
        ###echo -e "\n\tez van a vágólapon,\n\tezt tegyük be a szótárba?\n"
        echo -e "\n\t>> ${red}$(xclip -se c -o)${none} <<"
        ###echo -e "\tBeírhatsz mást,\n\tvagy ENTER:" 
        ###printf "\t"
        ###read szo

        if [ $(echo $szo | wc -m) -lt 2 ]; then
            szo="$(xclip -se c -o)"
        fi
        break
    # ha paraméter meg van adva
    else
        echo -e "\n\tEz a megadott paraméter:\n\t${red}$*${none}"
        sleep 0.7
        szo="$*"
        break
    fi
done

fix=${szo}

# bekérjük a fordítást a vágólapos szóhoz
forditas_shell=$(/usr/bin/trans -brief :hu "$fix")
echo -e "\n\tGoogle-translate:\n\t${green}$forditas_shell${none}"
echo -e "\n\tAdhatsz meg más fordítást\n\tvagy ${green}ENTER${none}\n"
printf "\t"
read varj

if [ $(echo $varj | wc -m) -ge 4 ]; then
   forditas_shell="$varj"
    echo -e "\n\tEz lesz hozzárendelve:\n\t${white}$forditas_shell${none}\n\t"
    read varj
    fi


while true; do
    printf "\t"
    if [ $(echo $forditas_shell | wc -m) -lt 2 ]; then
        read -p "Írd be, vagy másold ki a vágólapra a fordítást: " forditas
    else
        break
    fi
done

echo -e "${white}$fix${none} -- ${green}${forditas_shell}${none}" 
echo -e "$fix -- ${forditas_shell}" >> ${file}
echo

