# MangoHUD

## Links
[GitHuib / MangoHUD info](<https://sourcegraph.com/github.com/flightlessmango/MangoHud#fps-logging>)

## My testes
WINEARCH=win64 \
WINEDEBUG=fixme-all \
DXVK_HUD=1 \
MANGOHUD=1 \
MANGOHUD_LOG=1 \
MANGOHUD_DEBUG=1 \
MANGOHUD_CONFIG=full \
MANGOHUD_LOG_FILE=/home/dawciobiel/Games/battlenet-logs/fps_log.csv \
MANGOHUD_LOG_PER_MINUTE=1 \
MANGOHUD_DLSYM=1 \
WINEPREFIX="$HOME/Games/wine-10.7_staging" \
/usr/bin/wine "$HOME/Games/wine-10.7_staging/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"



MANGOHUD_LOG_PER_MINUTE=1 MANGOHUD=1 MANGOHUD_DEBUG=1 MANGOHUD_CONFIG=full 
 MANGOHUD_DLSYM=1 MANGOHUD_LOG_FILE=/home/dawciobiel/.config/MangoHud/fps_log toggle_logging=F2 output_file=/home/dawciobiel/.config/MangoHud/output_file output_folder=/home/dawciobiel/.config/MangoHud/output_folder  mangohud vkcube



MANGOHUD_LOG_PER_MINUTE=1 MANGOHUD_DEBUG=1 toggle_logging=F2 MANGOHUD=1 MANGOHUD_CONFIG=full MANGOHUD_DLSYM=1 output_folder=/home/dawciobiel/Games/battlenet-logs mangohud vkcube




- - -
To 
```shell
	MANGOHUD_OUTPUT_FOLDER=/home/dawciobiel/.config/MangoHud/fps_log MANGOHUD_OUTPUT_FILE=/home/dawciobiel/.config/MangoHud/fps_log output_folder=/home/dawciobiel/.config/MangoHud/fps_log MANGOHUD=1 MANGOHUD_LOG_FILE=/home/dawciobiel/.config/MangoHud/fps_log MANGOHUD_LOG_PER_MINUTE=1 MANGOHUD_DEBUG=1 mangohud vkcube
```
działało, tzn wyświetlało błąd
```log
	MANGOHUD: Failed to write log file
```

ale trzeba pamiętać, że w mangohud.config również były takie same wpisy co parametry tutaj.

Trzeba też rozpocząć logowanie za pomocą skrótu `Shitf+F2`


To 

```shell
	MANGOHUD_LOG_PER_MINUTE=1 MANGOHUD_DEBUG=1 toggle_logging=F2 MANGOHUD=1 MANGOHUD_CONFIG=full MANGOHUD_DLSYM=1 \ 
	output_folder=/home/dawciobiel/Games/battlenet-logs mangohud vkcube
```

niby działa, ale nie zapisuje danych do piku.
A jednak zapisuje, po zatrzymaniu - kolejnym naciśnięciem `Shift+F2` i zakończeniu graficznej aplikacji, torzy się plik:
```log
	[2025-05-13 08:03:39.244] [MANGOHUD] [info] [logging.cpp:79] /home/dawciobiel/vkcube_2025-05-13_07-59-56_summary.csv
```


