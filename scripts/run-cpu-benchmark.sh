#!/bin/bash

# 📅 Generowanie nazwy pliku z datą i godziną
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
logfile="benchmark-$timestamp.log"

# 🖊️ Funkcja pomocnicza do logowania z nagłówkiem
log_section() {
    echo -e "\n========== $1 ==========\n" | tee -a "$logfile"
}

# 🧠 Informacje o jądrze
log_section "Kernel Info"
uname -r | tee -a "$logfile"

# 🧵 Test sysbench – 1 wątek
log_section "Sysbench CPU Test – 1 Thread"
sysbench cpu --cpu-max-prime=20000 --threads=1 run | tee -a "$logfile"

# 🧵 Test sysbench – 2 wątki
log_section "Sysbench CPU Test – 2 Threads"
sysbench cpu --cpu-max-prime=20000 --threads=2 run | tee -a "$logfile"

# 🔧 Stress-ng – 2 wątki, matrixprod
log_section "Stress-ng CPU Test – 2 Threads (matrixprod)"
stress-ng --cpu 2 --cpu-method matrixprod --timeout 30s | tee -a "$logfile"

# 🔧 Stress-ng – 2 wątki, all methods
log_section "Stress-ng CPU Test – 2 Threads (all)"
stress-ng --cpu 2 --timeout 30s | tee -a "$logfile"

# 📈 Informacje o częstotliwości CPU
log_section "CPU Frequency Info"
cpupower frequency-info | tee -a "$logfile"

# ✅ Zakończenie
echo -e "\n✅ Benchmark zakończony. Wyniki zapisano w: $logfile\n"

