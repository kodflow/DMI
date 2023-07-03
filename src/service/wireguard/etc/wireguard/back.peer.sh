#!/bin/bash

# Vérification des arguments passés en ligne de commande
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <peer_name> <peer_ip>"
    exit 1
fi

# Récupération des arguments
peer_name=$1
peer_ip=$2

# Génération des clés pour le pair
umask 077
private_key=$(wg genkey)
public_key=$(echo "$private_key" | wg pubkey)

# Ajout du pair au fichier de configuration du serveur (wg0.conf)
echo "
[Peer]
PublicKey = $public_key
AllowedIPs = $peer_ip
" >> wg0.conf

# Enregistrement des clés dans des fichiers séparés
echo "$private_key" > "${peer_name}_private_key"
echo "$public_key" > "${peer_name}_public_key"

# Affichage de la clé publique du pair
echo "La clé publique du pair $peer_name est :"
echo "$public_key"
