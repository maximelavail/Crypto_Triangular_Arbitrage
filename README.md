# 🔥 Crypto Triangular Arbitrage  

## 📌 Description  
Crypto Triangular Arbitrage is a C++ project that retrieves Binance order book data via WebSockets to detect triangular arbitrage opportunities.  

## 🛠️ Installation  

### 1️⃣ Install Dependencies  
To install all necessary dependencies (Boost, OpenSSL, WebSocket++, etc.), simply run:  
```bash
./install.sh
```
This script will download and compile the required libraries in the `libs/` directory.  

### 2️⃣ Compile the Project  
Once the dependencies are installed, compile the project using:  
```bash
make
```
The executable will be generated in the `bin/` directory.  

### 3️⃣ Run the Program  
To start the application, execute:  
```bash
./bin/triangular_arbitrage
```

## 🧹 Cleaning  

- To remove compiled files:  
  ```bash
  make clean
  ```
- To completely remove dependencies and compiled files:  
  ```bash
  make distclean
  ```

## 📜 License  
This project is open-source and distributed under the MIT license.  

