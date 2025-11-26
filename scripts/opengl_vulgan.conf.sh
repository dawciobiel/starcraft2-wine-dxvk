#!/bin/bash

# OpenGL/Vulkan NVIDIA Settings Variables

# TODO UWAGA
# Część zmiennych występująca w tym pliku pokrywa się ze zmiennymi w dxvk.conf. Zmienne w dxvk.conf powinny być przeniesione tutaj.
# Przy czym nalezy sprawdzic czy zmienna moze byc ustwaiana w konfigu czy musi jako zmienna systemowa.

# Tryb kompozytora (tez wpływa na OpenGL)
export KWIN_TRIPLE_BUFFER=1

## OpenGL
# Tryb wydajności (zmniejszenie jakości w OpenGL)
# __GL_THREADED_OPTIMIZATIONS - Forcing threaded optimization (może poprawić wydajność w niektórych grach)
export __GL_THREADED_OPTIMIZATIONS=1    # może przyspieszyć
export __GL_SHADER_DISK_CACHE=1         # cache shaderów
export __GL_LOG_ERRORS=0                # mniej debug info
export __GL_FORCE_SOFTWARE_GPU=0        # wymuszenie GPU, nie CPU

# Wymuszenie trybu "Performance" kosztem jakości
# __GL_PERF_PROFILE symuluje ten suwak w GUI. Wartość 1 wymusza tryb Performance.
export __GL_PERF_PROFILE=1
# 0 = Application controlled
# 1 = Performance
# 2 = Default
# 3 = Quality

## Vulkan
# asynchronous shader compilation - DXVK_ASYNC
export DXVK_ASYNC=1             # asynchronous shader compilation, przyspiesza start
# export DXVK_HUD=0               # wyłącza nakładkę DXVK // Istnieje w dxvk.conf
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
export VK_LAYER_PATH=/usr/share/vulkan/explicit_layer.d

# Debugowanie problemow z `VK_ERROR_OUT_OF_HOST_MEMORY`
export DXVK_MEMORY_TRACKER=0
export DXVK_LOG_LEVEL=none
# DXVK_LOG_LEVEL
# none → wyłącza logi całkowicie (najczystsze uruchomienie, brak plików .log).
# error → loguje tylko błędy krytyczne.
# warn → loguje błędy i ostrzeżenia.
# info → loguje podstawowe informacje (domyślne).
# debug → loguje wszystko, bardzo szczegółowe (dla developerów).

export DXVK_ENABLE_PIPECOMPILER=0

