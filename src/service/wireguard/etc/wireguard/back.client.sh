#!/bin/bash

# Récupération de la clé privée du pair
read -p "Entrez la clé privée du pair : " private_key

# Récupération de l'adresse IP du serveur
read -p "Entrez l'adresse IP du serveur : " server_ip

# Récupération du port d'écoute du serveur
read -p "Entrez le port d'écoute du serveur : " server_port

# Récupération du nom souhaité pour la configuration du pair
read -p "Entrez un nom pour la configuration du pair : " config_name

# Génération de la clé publique du pair
public_key=$(echo "$private_key" | wg pubkey)

# Création du fichier de configuration du pair
echo "[Interface]
PrivateKey = $private_key
Address = 10.0.0.1
DNS = 8.8.8.8
MTU = 1420
[Peer]
PublicKey = $(cat server_public_key)
Endpoint = $server_ip:$server_port
AllowedIPs = 0.0.0.0/0, ::/0" > "$config_name.conf"

# Ajout du pair au fichier de configuration du pair
echo "
[Peer]
PublicKey = $public_key
AllowedIPs = 10.0.0.2/24
" >> "$config_name.conf"

# Affichage du contenu du fichier de configuration du pair
echo "Le contenu du fichier de configuration du pair $config_name est :"
cat "$config_name.conf"
