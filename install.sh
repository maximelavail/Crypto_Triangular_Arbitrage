#!/bin/bash

set -e  # Arrête le script en cas d'erreur

echo "🔹 Détection du système d'exploitation..."

# Détecter l'OS
OS="$(uname -s)"

install_mac() {
    echo "🍏 macOS détecté, utilisation de Homebrew..."
    
    # Vérifier si Homebrew est installé
    if ! command -v brew &>/dev/null; then
        echo "❌ Homebrew n'est pas installé. Installez-le d'abord via :"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    echo "📥 Installation des dépendances..."
    brew install boost openssl
}

install_debian() {
    echo "🐧 Ubuntu/Debian détecté, utilisation d'APT..."
    sudo apt update
    sudo apt install -y libboost-all-dev libssl-dev
}

install_arch() {
    echo "🐧 Arch Linux détecté, utilisation de Pacman..."
    sudo pacman -Sy --noconfirm boost openssl
}

case "$OS" in
    Darwin)
        install_mac
        ;;
    Linux)
        if [ -f /etc/debian_version ]; then
            install_debian
        elif [ -f /etc/arch-release ]; then
            install_arch
        else
            echo "❌ Distribution Linux non supportée. Installez Boost et OpenSSL manuellement."
            exit 1
        fi
        ;;
    *)
        echo "❌ Système non supporté."
        exit 1
        ;;
esac

echo "✅ Installation terminée avec succès ! 🚀"