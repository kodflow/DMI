#!/bin/bash

# Demande des informations pour créer un nouveau pair (peer)
read -p "Entrez un nom pour le pair : " peer_name
read -p "Entrez une adresse IP pour le pair (au format CIDR, ex. 10.0.0.2/24) : " peer_ip

# Génération des clés pour le pair
umask 077
wg genkey | tee ${peer_name}_private_key | wg pubkey > ${peer_name}_public_key

# Ajout du pair au fichier de configuration du serveur (wg0.conf)
echo "
[Peer]
PublicKey = $(cat ${peer_name}_public_key)
AllowedIPs = ${peer_ip}
" >> wg0.conf

# Affichage de la clé publique du pair
echo "La clé publique du pair ${peer_name} est :"
cat ${peer_name}_public_key
