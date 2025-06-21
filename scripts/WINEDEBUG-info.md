# Opis zmiennej WINEDEBUG

`WINEDEBUG=`
+all	Wszystko (dużo i wolno — używaj tylko przy głębokim debugowaniu)
-all	Wyłącza wszystkie logi
+err	Tylko błędy
+warn	Ostrzeżenia
+fixme	Logi typu „fixme” (często nie zaimplementowane funkcje)
+seh	Obsługa wyjątków Windows (Structured Exception Handling)
+tid	Dodaje ID wątku do każdego wpisu logu
+timestamp	Dodaje znacznik czasu
+relay	Szczegółowe śledzenie wywołań funkcji WinAPI (wolne i bardzo obszerne)
+d3d, +d3d11, +vulkan	Logowanie grafiki i interfejsów DX/Vulkan


## Przykłady
Tylko błędy i ostrzeżenia:
    WINEDEBUG=+err,+warn wine app.exe

Wyłącz wszystko:
    WINEDEBUG=-all wine app.exe

Loguj błędy i funkcje Direct3D:
    WINEDEBUG=+err,+d3d wine app.exe

Dodaj znacznik czasu i ID wątku (do lepszej analizy logu):
    WINEDEBUG=+tid,+timestamp,+err wine app.exe

    
    
**Uwaga**
Użycie +relay i +all może bardzo spowolnić działanie aplikacji, a logi mogą ważyć setki MB. Używaj tylko, gdy naprawdę trzeba.
