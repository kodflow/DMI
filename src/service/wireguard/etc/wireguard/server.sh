#!/bin/bash

# Génération des clés pour le serveur
umask 077
wg genkey | tee server_private_key | wg pubkey > server_public_key

# Création du fichier de configuration du serveur (wg0.conf)
echo "[Interface]
PrivateKey = $(cat server_private_key)
Address = 10.0.0.1/24
ListenPort = 51820

# Uncomment the following lines if you want to use DNS
# DNS = 8.8.8.8
# MTU = 1420

# Uncomment the following line if you want to enable persistent keepalive
# PersistentKeepalive = 25" > wg0.conf

# Affichage de la clé publique du serveur
echo "La clé publique du serveur est :"
cat server_public_key
