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

while [[ OPERACJA -ne 8 ]]; do
    echo "1. Nazwa pliku: $NAZWA"
    echo "2. Katalog: $KATALOG"
    echo "3. Rozmiar pliku w kb: $ROZMIAR"
    echo "4. Plik ostatni raz edytowany mniej niz $MINUTY min. temu "
    echo "5. Typ pliku: $TYP"
    echo "6. Zawartosc: $ZAWARTOSC"
    echo "7. Szukaj"
    echo "8. Koniec"
    read OPERACJA

    if [[ $OPERACJA -eq 1 ]]; then
        read NAZWA
        if [[ -z $NAZWA ]]; then
            NAZWAARG=""
        else
            NAZWAARG="-name $NAZWA "
        fi
    fi

    if [[ $OPERACJA -eq 2 ]]; then
        read KATALOG
        if [[ -z $KATALOG ]]; then
            KATALOGARG=""
        else
            KATALOGARG="$KATALOG "
        fi
    fi

    if [[ $OPERACJA -eq 3 ]]; then
        read ROZMIAR
        if [[ -z $ROZMIAR ]]; then
            ROZMIARARG=""
        else
            ROZMIARARG="-size ${ROZMIAR}k "
        fi
    fi

    if [[ $OPERACJA -eq 4 ]]; then
        read MINUTY
        if [[ -z $MINUTY ]]; then
            MINUTYARG=""
        else
            MINUTYARG="-mmin -$MINUTY "
        fi
    fi

    if [[ $OPERACJA -eq 5 ]]; then
        read TYP
        if [[ -z $TYP ]]; then
            TYPARG=""
        else
            TYPARG="-type $TYP "
        fi
    fi

    if [[ $OPERACJA -eq 6 ]]; then
        read ZAWARTOSC
        if [[ -z $ZAWARTOSC ]]; then
            ZAWARTOSCARG=""
        else
            ZAWARTOSCARG="-exec grep -l \"$ZAWARTOSC\" {} \;"
        fi
    fi

    if [[ $OPERACJA -eq 7 ]]; then
        eval "find $KATALOGARG $NAZWAARG $ROZMIARARG $TYPARG $MINUTYARG $ZAWARTOSCARG"
    fi
done
