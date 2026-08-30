# LogicRail-FPGA-based-Rail-Control-Simulator
Dynamic rail control simulator based on the FPGA boards Basys3
Logic Rail to w pełni sprzętowy, rozproszony symulator systemu sterowania ruchem kolejowym (SRK) napisany w języku SystemVerilog. Projekt jest implementowany na układach FPGA (Digilent Basys3).
Architektura projektu opiera się na rozproszonej logice sprzętowej. Składa się z następujących elementów:

Stacja A & Stacja B (FPGA - Digilent Basys): Dwa niezależne węzły sprzętowe komunikujące się ze sobą fizycznym łączem (UART). Płytki wymieniają informacje o wyprawianych pociągach i stanach szlaku, realizując sprzętowe maszyny stanów (FSM) dla zależności kolejowych (interlocking).

Sprzętowy Kontroler VGA: Zaimplementowany w SystemVerilogu moduł generujący sygnały synchronizacji (HSYNC/VSYNC) oraz sygnał wizyjny RGB. Moduł na bieżąco renderuje układ torów, stany semaforów oraz pozycje pociągów bezpośrednio na podłączonym monitorze.

Custom I/O & Interfejs Dyspozytora: Zamiast standardowej aplikacji okienkowej, system przyjmuje sygnały sterujące z dedykowanego pulpitu, pozwalając na interakcję z symulacją w czasie rzeczywistym.

# Ważne informacje

# Załadowanie projektu dla systemu Linux:
# Sklonuj repozytorium i wejdź do folderu
'''bash
git clone [https://github.com/](https://github.com/)<TWÓJ_PROFIL>LogicRail-FPGA-based-Rail-Control-Simulator.git
'''
'''bash
cd LogicRail-FPGA-based-Rail-Control-Simulator
'''

# Załaduj zmienne środowiskowe Vivado (zmień ścieżkę/wersję na własną)
'''bash
source /tools/Xilinx/Vivado/2025.2/settings64.sh
'''

# Wygeneruj strukturę projektu bez otwierania interfejsu graficznego
'''bash
vivado -mode batch -source build.tcl
'''
# Załadowanie projektu dla systemu Windows:
# Sklonuj repozytorium i wejdź do folderu
'''bash
git clone [https://github.com/](https://github.com/)<TWÓJ_PROFIL>/LogicRail-FPGA-based-Rail-Control-Simulator.git
'''
'''bash
cd LogicRail-FPGA-based-Rail-Control-Simulator
'''
'''bash
# Wygeneruj strukturę projektu podając pełną ścieżkę do instalacji Vivado
C:\Xilinx\Vivado\2025.2\bin\vivado.bat -mode batch -source build.tcl
'''

Aby zaktualizować projekt po dodania np. modułu potrzebne jest zaktualizowanie skryptu   build.tcl Robimy to poprzez wpisanie
'''bash
write_project_tcl -force build.tcl
