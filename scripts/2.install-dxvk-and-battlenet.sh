#!/bin/bash
#
# install-battlenet.sh
# Description: Installs Battle.net Launcher into a specified WINEPREFIX.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-07

# === Configuration ===
# Read wine variables
source wine.conf

# Show all variables in DEBUG MODE
if [ "$DEBUG_MODE" = "1" ]; then
    echo "DEBUG_MODE true"
    set -x
fi

# === Check if Battle.net installer exists ===
if [ ! -f "$BATTLENET_INSTALLER" ]; then
  echo "❌ Battle.net installer not found in the current directory."
  echo "🔗 Download it from: https://www.blizzard.com/download"
  exit 1
fi

# === Create a fresh 64-bit WINEPREFIX ===
echo "📦 Creating a new 64-bit WINEPREFIX... - fixme: winboot -u is updating already existed wine configuration after system update or update of wine"
WINEARCH="$WINEARCH" WINEPREFIX="$WINEPREFIX" wineboot -u

# === Install corefonts, vcrun2017, and set Windows 10 as the version ===
echo "🔧 Installing corefonts, vcrun2017, and setting Windows 10..."
WINEPREFIX="$WINEPREFIX" winetricks -q corefonts vcrun2017 settings win10

# === Install DXVK for better performance ===
echo "⚙️ Installing DXVK for better performance..."
# Sposób A)
echo "By method [ WINEPREFIX=\"$HOME/Games/wine-10.18_staging\" setup_dxvk install ]"
WINEPREFIX="$HOME/Games/wine-10.18_staging" setup_dxvk install

# Dodaj override'y w winecfg
echo ""
echo "Add overrides"
echo "   Przejdź do zakładki Biblioteki"
echo "   Dodaj biblioteki jako '(najpierw zewnątrzna, potem wbudowana)' czyli '(native, builtin)'"
echo "      d3d11 (native, builtin)"
echo "      d3d10core (native, builtin)"
echo "      d3d9 (native, builtin)"
echo "      d3d8 (native, builtin)"
echo "      dxgi (native, builtin)"
echo ""
echo "  Na tej liście może występować tylko jedna pozycja z 'dxd11...dxgi'. "
echo ""
echo "⚠️ Nie wszystkie gry dobrze działają z DXVK dla DX9 — jeśli zauważysz problemy z grafiką, możesz cofnąć override dla d3d9 i pozwolić Wine używać własnej wersji."

read -r -p "Naciśnij [Enter], aby ręcznie ustawić overrides w winecfg..."


WINEPREFIX="$HOME/Games/wine-10.18_staging" winecfg
# ✅ Zalety:
# Pełna kontrola nad wersją DXVK (np. lokalna paczka z GitHub)
# Możesz zainstalować DXVK do wielu prefixów ręcznie
# Pokazuje dokładnie, które pliki są kopiowane i gdzie
# Idealne do skryptów, custom launcherów i debugowania
#
# ⚠️ Wady:
# Musisz mieć lokalnie sklonowane lub zainstalowane DXVK
# Nie ustawia rejestru ani override'ów — trzeba to zrobić ręcznie w winecfg

# Sposób B)
# echo "By method [ WINEPREFIX=\"$WINEPREFIX\" winetricks -q dxvk ]"
# WINEPREFIX="$WINEPREFIX" winetricks -q dxvk
# winetricks doda override'y automatycznie.
# ✅ Zalety:
# Automatyczna instalacja DXVK do wskazanego prefixu
# Pobiera najnowszą wersję DXVK z repozytorium
# Ustawia odpowiednie wpisy w rejestrze Wine
# Działa dobrze dla większości gier
#
# ⚠️ Wady:
# Brak kontroli nad wersją DXVK
# Nie pokazuje dokładnie, które pliki są kopiowane
# Może nadpisać ręczne ustawienia lub DLL-e

# === Launching Battle.net installer installer ===
echo "🚀 Launching Battle.net installer..."
WINEPREFIX="$WINEPREFIX" wine "$BATTLENET_INSTALLER"

