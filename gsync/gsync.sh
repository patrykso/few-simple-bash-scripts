#!/bin/bash
PASS=""
SCIEZKA=""
REMOVE="FALSE"
GDRIVECATALOG=""
while getopts "rvhdp:c:g:" OPTION; do
    case "$OPTION" in
        p)
            PASS="$OPTARG"
            ;;
        c)
            SCIEZKA="$OPTARG"
            ;;
        d)
            DATA=`date "+%Y-%m-%d-%H-%M-%S"`
            ;;
        r)
            REMOVE="TRUE"
            ;;
        g)
            GDRIVECATALOG="-p $OPTARG"
            ;;
        h)
            echo "Skrypt monitoruje katalog pod katem nowych plikow, szyfruje je wybranym przez uzytkownika haslem i wysyla do chmury Google Drive"
            echo "Jezeli uzytkownik nie poda zadnego hasla, haslem domyslnym jest <<ZyrafyWchodzaDoSzafy>>"
            echo "Jezeli uzytkownik nie poda katalogu, automatycznie zostanie utworzony katalog pod nazwa gsync"
            echo "Mozliwe flagi: -h -v -d -r -c <<bezwzgledna sciezka>> -p <<haslo>> -g <<id katalogu>>"
            exit 1
            ;;
        v)
            echo "Autor skryptu Patryk Sowinski-Toczek, licencja MIT"
            echo "Skrypt korzysta z narzedzi gdrive (licencja MIT)"
            echo "Wersja skryptu: 1.00"
            echo "Skrypt wykonany na potrzeby zajec z Systemow Operacyjnych"
            exit 1
            ;;
        ?)
            echo "Mozliwe flagi: -h -v -d -r -c <<bezwzgledna sciezka>> -p <<haslo>> -g <<id katalogu>>"
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# jesli haslo nie zostalo ustalone
if [[ -z $PASS ]]; then
    PASS="ZyrafyWchodzaDoSzafy"
fi

# jesli sciezka nie zostala podana
if [[ -z $SCIEZKA ]]; then
    mkdir gsync
    pwd=$(pwd)
    SCIEZKA="$pwd/gsync"
fi

echo "Skrypt zostal uruchomiony"
TMPfile=""
inotifywait -m $SCIEZKA -e create -e moved_to |
    while read directory action file; do
    # ten warunek jest potrzebny, aby nie doszlo do nieskoczonej petli tworzacych sie archiwow
        if [[ "$file" != "$TMPfile" ]] && [[ "$file" != "$DATA.7z" ]]; then
        #ten if sprawdza czy uzytkownik wlaczyl flage, ktora sprawia, ze pliki nazywane sa po dacie
            if [[ -z $DATA ]]; then
                TMPfile="$file.7z"
                #dodawanie pliku do archiwum oraz jego szyfrowanie zgodnie z haslem podanym przez uzytkownika
                cd $SCIEZKA
                7z a $file.7z -p$PASS -mhe $file
                # wysylanie zaszyfrowanego pliku na serwer
                $HOME/gdrive upload $GDRIVECATALOG $SCIEZKA/$file.7z
                # usuwanie zaszyfrowanego pliku 
                rm $file.7z
                # usuwanie pliku zalezne od flagi
                if [[ "$REMOVE" == "TRUE" ]]; then
                    rm $file
                fi
            else
                #pobiera nowa date
                DATA=`date "+%Y-%m-%d-%H-%M-%S"`
                TMPfile="$DATA.7z"
                cd $SCIEZKA
                7z a $DATA.7z -p$PASS -mhe $file
                $HOME/gdrive upload $GDRIVECATALOG $SCIEZKA/$DATA.7z
                rm $DATA.7z
                if [[ "$REMOVE" == "TRUE" ]]; then
                    rm $file
                fi
            fi
        fi
    done
