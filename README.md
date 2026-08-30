# LogicRail-FPGA-based-Rail-Control-Simulator
Dynamic rail control simulator based on the FPGA boards Basys3
Logic Rail to w pełni sprzętowy, rozproszony symulator systemu sterowania ruchem kolejowym (SRK) napisany w języku SystemVerilog. Projekt jest implementowany na układach FPGA (Digilent Basys3).
Architektura projektu opiera się na rozproszonej logice sprzętowej. Składa się z następujących elementów:

Stacja A & Stacja B (FPGA - Digilent Basys): Dwa niezależne węzły sprzętowe komunikujące się ze sobą fizycznym łączem (UART). Płytki wymieniają informacje o wyprawianych pociągach i stanach szlaku, realizując sprzętowe maszyny stanów (FSM) dla zależności kolejowych (interlocking).

Sprzętowy Kontroler VGA: Zaimplementowany w SystemVerilogu moduł generujący sygnały synchronizacji (HSYNC/VSYNC) oraz sygnał wizyjny RGB. Moduł na bieżąco renderuje układ torów, stany semaforów oraz pozycje pociągów bezpośrednio na podłączonym monitorze.

Custom I/O & Interfejs Dyspozytora: Zamiast standardowej aplikacji okienkowej, system przyjmuje sygnały sterujące z dedykowanego pulpitu oraz zewnętrznej myszy sprzętowej (protokół PS/2), pozwalając na interakcję z symulacją w czasie rzeczywistym.

Ważne informacje
Aby zaktualizować projekt po dodania np. modułu potrzebne jest zaktualizowanie skryptu   build.tcl Robimy to poprzez wpisanie
'''bash
write_project_tcl -force build.tcl
'''
w tcl console w Vivado. Za pomoca komendy cd wejdz do folderu projektu (LogicRail-FPGA.....) aby nadpisać istniejacy już plik.
