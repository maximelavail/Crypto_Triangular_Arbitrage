#!/bin/bash

set -e  # Arrête le script en cas d'erreur

LIBS_DIR="libs"
BOOST_DIR="$LIBS_DIR/boost"

echo "🔹 Installation des dépendances dans $LIBS_DIR..."

# 📥 Installation de Boost
if [ ! -d "$BOOST_DIR" ]; then
    echo "📥 Téléchargement de Boost..."
    git clone --recurse-submodules https://github.com/boostorg/boost.git "$BOOST_DIR"
else
    echo "✅ Boost déjà téléchargé."
fi

echo "🔄 Mise à jour des sous-modules de Boost..."
cd "$BOOST_DIR"
git submodule update --init --recursive

echo "⚙️ Compilation de Boost..."
./bootstrap.sh
./b2 install --prefix=$(pwd)
cd ../../

echo "✅ Boost installé avec succès ! 🎉"

# 📥 Installation d'OpenSSL (si nécessaire)
OPENSSL_DIR="$LIBS_DIR/openssl"
if [ ! -d "$OPENSSL_DIR" ]; then
    echo "📥 Téléchargement et compilation d'OpenSSL..."
    mkdir -p "$OPENSSL_DIR"
    cd "$OPENSSL_DIR"
    curl -O https://www.openssl.org/source/openssl-3.0.2.tar.gz
    tar -xzf openssl-3.0.2.tar.gz
    cd openssl-3.0.2
    ./config --prefix=$(pwd)/../ --openssldir=$(pwd)/../ssl
    make -j$(nproc)
    make install
    cd ../../../
    echo "✅ OpenSSL installé avec succès ! 🎉"
else
    echo "✅ OpenSSL déjà installé."
fi

echo "🚀 Toutes les bibliothèques ont été installées avec succès !"