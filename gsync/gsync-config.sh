#!/bin/bash
echo "To jest skrypt konfiguracyjny"
OPERACJA=""
while [[ $OPERACJA != "TAK" ]]; do
    echo "Wpisz TAK jezeli chcesz dokonac konfiguracji, lub NIE, aby zakonczyc dzialanie skryptu"
    read OPERACJA
    if [[ $OPERACJA == "NIE" ]]; then
        unset OPERACJA
        exit 1
    fi
done
unset OPERACJA
echo "Teraz zostanie zainstalowany p7zip oraz inotify-tools"
sudo yum -y install p7zip p7zip-plugins inotify-tools
echo "Teraz zostanie zainstalowany gdrive (w katalogu domowym)"
wget https://github.com/prasmussen/gdrive/releases/download/2.1.1/gdrive_2.1.1_linux_386.tar.gz
tar -xvf gdrive_2.1.1_linux_386.tar.gz
echo "Polacz skrypt ze swoim kontem Google (wejdz w link i przeklej authentication code)"
$HOME/gdrive about
rm $HOME/gdrive_2.1.1_linux_386.tar.gz
$HOME/gdrive about
echo "Jezeli powyzej widzisz swoje dane, konfiguracja przebiegla pomyslnie"
