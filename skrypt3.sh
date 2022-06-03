#!/bin/bash
OPERACJA=""
NAZWA=""
NAZWAART=""
KATALOG=""
KATALOGARG=""
ROZMIAR=""
ROZMIARARG=""
ZAWARTOSC=""
ZAWARTOSCARG=""
TYP=""
TYPARG=""
MINUTY=""
MINUTYARG=""

while [[ true ]]; do
    menu=(\
    "Nazwa pliku: $NAZWA" \
    "Katalog: $KATALOG" \
    "Rozmiar pliku w kb: $ROZMIAR" \
    "Plik ostatni raz edytowany mniej niz $MINUTY min. temu" \
    "Typ pliku: $TYP" \
    "Zawartosc: $ZAWARTOSC" \
    "Szukaj" \
    "Koniec")
    odp=`zenity --list --column=Menu "${menu[@]}" --height 320 --width 400`

    if [[ $odp == "Nazwa pliku: $NAZWA" ]]; then
        NAZWA=$(zenity --entry --title "Nazwa" --text "Wprowadź nazwę szukanych plików") #
        if [[ -z $NAZWA ]]; then
            NAZWAARG=""
        else
            NAZWAARG="-name $NAZWA "
        fi
    fi

    if [[ $odp == "Katalog: $KATALOG" ]]; then
        KATALOG=$(zenity --entry --title "Katalog" --text "Podaj ścieżkę, w której chciałbyś wyszukać pliki (np. xxx/yyy lub xxx)") #
        if [[ -z $KATALOG ]]; then
            KATALOGARG=""
        else
            KATALOGARG="$KATALOG "
        fi
    fi

    if [[ $odp == "Rozmiar pliku w kb: $ROZMIAR" ]]; then
        ROZMIAR=$(zenity --entry --title "Rozmiar" --text "Podaj rozmiar (w kb) szukanych plików.") #
        if [[ -z $ROZMIAR ]]; then
            ROZMIARARG=""
        else
            ROZMIARARG="-size ${ROZMIAR}k "
        fi
    fi

    if [[ $odp == "Plik ostatni raz edytowany mniej niz $MINUTY min. temu" ]]; then
        MINUTY=$(zenity --entry --title "Minuty" --text "Podaj czas (w minutach), aby znaleźć plik lub pliki, \nktóre były edytowane mniej niż x podanych przez ciebie minut.") #
        if [[ -z $MINUTY ]]; then
            MINUTYARG=""
        else
            MINUTYARG="-mmin -$MINUTY "
        fi
    fi

    if [[ $odp == "Typ pliku: $TYP" ]]; then
        TYP=$(zenity --entry --title "Typ" --text "Podaj typ szukanego pliku (np. d lub f)") #
        if [[ -z $TYP ]]; then
            TYPARG=""
        else
            TYPARG="-type $TYP "
        fi
    fi

    if [[ $odp == "Zawartosc: $ZAWARTOSC" ]]; then
        ZAWARTOSC=$(zenity --entry --title "Zawartość" --text "Wprowadź szukaną w plikach zawartość")
        if [[ -z $ZAWARTOSC ]]; then
            ZAWARTOSCARG=""
        else
            ZAWARTOSCARG="-exec grep -l \"$ZAWARTOSC\" {} \;"
        fi
    fi

    if [[ $odp == "Szukaj" ]]; then
        eval "find $KATALOGARG $NAZWAARG $ROZMIARARG $TYPARG $MINUTYARG $ZAWARTOSCARG" \
        | zenity --text-info --height 320 --width 400 –-title "Lista plików"
    fi

    if [[ $odp == "Koniec" ]]; then
        break
    fi

done
