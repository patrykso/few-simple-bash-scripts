#!/bin/bash
OPERACJA=""
echo "Przed korzystaniem ze skryptu przeprowadz konfiguracje uruchamiajac gsync-config.sh!"
echo "Wpisz TAK, jezeli przeprowadziles konfiguracje lub NIE, jezeli jeszcze tego nie zrobiles (zostanie uruchomiony skrypt konfiguracyjny)"
echo "Mozesz tez wpisac WYJDZ, aby wylaczyc skrypt".

while [[ $OPERACJA != "TAK" ]]; do
    read OPERACJA
    if [[ $OPERACJA == "NIE" ]]; then
        eval "sudo ./gsync-config.sh"
    fi

    if [[ $OPERACJA == "WYJDZ" ]]; then
        exit 1
    fi
done
unset OPERACJA

PASS=""
PASScheck=""

while [[ true ]]; do
    echo "Wprowadz haslo, ktorym szyfrowane beda pliki wysylane do chmury"
    read -s PASS
    echo "Wprowadz haslo ponownie"
    read -s PASScheck
    if [[ $PASS == $PASScheck ]]; then
        break
    else
        echo "Hasla sie nie zgadzaja!"
    fi
done
unset PASScheck

SCIEZKA=""
CZAS=""
echo "Podaj bezwzgledna sciezke do katalogu z ktorego pliku maja byc wysylane do chmury"
echo "np. /home/admin/dokumenty"
echo "Sciezka do katalogu, w ktorym obecnie sie znajdujesz: "
pwd
read SCIEZKA

TMPfile=""
inotifywait -m $SCIEZKA -e create -e moved_to |
    while read directory action file; do
        if [[ "$file" != "$TMPfile" || "$file" != "log.txt" ]]; then #ten warunek jest potrzebny, aby nie doszlo do nieskoczonej petli tworzacych sie archiwow
            TMPfile="$file.7z"
            7z a $file.7z -p$PASS $file # tutaj dodac date i nazwe, zgodnie z projektem
            #dodawanie pliku do archiwum oraz jego szyfrowanie zgodnie z haslem podanym przez uzytkownika
            $HOME/gdrive upload $SCIEZKA/$file.7z
            rm $file.7z
        fi
    done
