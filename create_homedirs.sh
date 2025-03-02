#!/bin/bash

# Basisverzeichnis für Home-Ordner
BASE_DIR="/home"

# FreeIPA-Benutzer abrufen (nur aktive Benutzer mit UID >= 1000)
USERS=$(ipa user-find --all --raw | grep 'uid: ' | awk '{print $2}')

# Prüfen, ob die Benutzerliste leer ist
if [[ -z "$USERS" ]]; then
    echo "Keine Benutzer gefunden!"
    exit 1
fi

# Durch die Benutzerliste iterieren und Home-Verzeichnisse erstellen
for user in $USERS; do
    HOME_DIR="$BASE_DIR/$user"

    if [ ! -d "$HOME_DIR" ]; then
        mkdir -p "$HOME_DIR"
        chown "$user:$user" "$HOME_DIR"
        chmod 700 "$HOME_DIR"
        echo "Home-Verzeichnis für $user erstellt: $HOME_DIR"
    else
        echo "Home-Verzeichnis für $user existiert bereits."
    fi
done
