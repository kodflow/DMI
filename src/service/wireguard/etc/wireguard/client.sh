#!/bin/bash

# Vérification des arguments passés en ligne de commande
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <peer_name> <peer_ip> <server_public_key> <preshared_key>"
    exit 1
fi

# Récupération des arguments
peer_name=$1
peer_ip=$2
server_public_key=$3
preshared_key=$4

# Génération de la clé privée et publique pour le pair
private_key=$(wg genkey)
public_key=$(echo "$private_key" | wg pubkey)

# Ajout du pair au fichier de configuration du serveur (wg0.conf)
echo "
[Peer]
PublicKey = $public_key
AllowedIPs = $peer_ip
PresharedKey = $preshared_key
" >> wg0.conf

# Création du fichier de configuration pour le client
echo "[Interface]
PrivateKey = $private_key
Address = $peer_ip
DNS = 8.8.8.8
MTU = 1420

[Peer]
PublicKey = $server_public_key
AllowedIPs = 0.0.0.0/0
Endpoint = <server_ip>:<server_port>
PresharedKey = $preshared_key" > "${peer_name}_client.conf"

echo "Le pair $peer_name a été ajouté au fichier de configuration du serveur wg0.conf."
echo "Le fichier de configuration du client ${peer_name}_client.conf a été créé avec succès."
