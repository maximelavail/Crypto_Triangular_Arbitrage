# Nom de l'exécutable
TARGET = triangular_arbitrage

# Dossiers
SRC_DIR = srcs
INC_DIR = include
BUILD_DIR = build
BIN_DIR = bin

# Compilateur
CXX = g++

# Options de compilation
CXXFLAGS = -std=c++17 -Wall -Wextra -O2

# Détection automatique du système d'exploitation et configuration des dépendances
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Darwin)  # macOS
    BOOST_INCLUDE := $(shell brew --prefix boost)/include
    BOOST_LIB := $(shell brew --prefix boost)/lib
    OPENSSL_INCLUDE := $(shell brew --prefix openssl)/include
    OPENSSL_LIB := $(shell brew --prefix openssl)/lib
else ifeq ($(shell which apt 2>/dev/null), /usr/bin/apt)  # Debian/Ubuntu
    BOOST_INCLUDE := /usr/include
    BOOST_LIB := /usr/lib
    OPENSSL_INCLUDE := /usr/include
    OPENSSL_LIB := /usr/lib
else ifeq ($(shell which pacman 2>/dev/null), /usr/bin/pacman)  # Arch Linux
    BOOST_INCLUDE := /usr/include
    BOOST_LIB := /usr/lib
    OPENSSL_INCLUDE := /usr/include
    OPENSSL_LIB := /usr/lib
else
    $(error ❌ Système non supporté. Installez Boost et OpenSSL manuellement.)
endif

# Options d'inclusion et de liaison
INCLUDES = -I$(BOOST_INCLUDE) -I$(OPENSSL_INCLUDE) -I$(INC_DIR)
LIBS = -L$(BOOST_LIB) -L$(OPENSSL_LIB) -lboost_system -lboost_thread -lssl -lcrypto -lpthread

# Fichiers sources et objets
SRC = $(wildcard $(SRC_DIR)/*.cpp)
OBJ = $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SRC))

# Règle principale : compilation de l'exécutable dans bin/
$(BIN_DIR)/$(TARGET): $(OBJ) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $(OBJ) -o $@ $(INCLUDES) $(LIBS)

# Compilation des fichiers sources en objets (dans build/)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Création des dossiers build/ et bin/ si inexistants
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Nettoyage
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)