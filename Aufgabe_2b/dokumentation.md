# Dokumentation: Finite State Machine (Wetter-System)

## Zustands-Tabelle (State Table)

| Aktueller Zustand | Event / Bedingung | Naechster Zustand | Aktion (Visualisierung) |
| :--- | :--- | :--- | :--- |
| **SUNNY** (Sonnig) | Timer erreicht 0s | **RAINY** | Icon wird gelb und dreht sich. |
| **RAINY** (Regen) | Timer erreicht 0s | **STORMY** | Icon wird blau und faellt nach unten. |
| **STORMY** (Sturm) | Timer erreicht 0s | **SUNNY** | Icon wird grau und wackelt stark. |

Git feature branch update.
