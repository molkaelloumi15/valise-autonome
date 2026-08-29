# 🧳 Valise Autonome

Projet académique (2ᵉ année d'ingénieur, ENSIT, 2024–2025) réalisé en binôme (Molka Elloumi & Fakhri Menjli) : une valise connectée capable de **suivre automatiquement son propriétaire**, d'**éviter les obstacles**, et pilotable via une **application mobile Flutter**.

## 🎯 Fonctionnalités principales

| Fonctionnalité | Description |
|---|---|
| **Suivi autonome** | La valise détecte la position de son propriétaire en temps réel et le suit automatiquement. |
| **Navigation & évitement d'obstacles** | Détection et contournement des obstacles fixes et mobiles à l'aide de capteurs ultrasoniques. |
| **Mode manuel** | Contrôle manuel de la valise depuis l'application mobile. |
| **Notifications** | Alerte envoyée au smartphone en cas de perte de connexion avec la valise. |
| **Autonomie** | Batterie lithium-ion dimensionnée pour au moins 8h d'utilisation continue. |

## 🧠 Principe de fonctionnement

La valise embarque un microcontrôleur **ESP32** qui :
1. Estime la distance au smartphone du propriétaire à partir de la puissance du signal Wi-Fi (RSSI).
2. Mesure en parallèle la distance aux obstacles via un capteur ultrasonique.
3. Compare les deux mesures pour distinguer un vrai obstacle d'un simple éloignement du propriétaire, et ajuste le déplacement des moteurs en conséquence.
4. Expose ces données via un petit serveur web embarqué (mode point d'accès Wi-Fi), interrogé par l'application mobile.

## 🛠️ Stack technique

- **Firmware** : C++ (Arduino), ESP32, capteurs ultrasoniques HC-SR04, moteurs CC à engrenages FIT0564
- **Électronique** : PCB personnalisé conçu sous **KiCad**, prototypage sous **Proteus 8 ISIS**
- **Application mobile** : **Flutter** (architecture MVVM) — authentification, écran d'accueil, suivi en temps réel, réglages
- **Outils** : Arduino IDE, VS Code, KiCad

## 📂 Structure du dépôt

```
.
├── firmware/           # Code embarqué ESP32 (Arduino)
│   └── valise_autonome.ino
├── circuit/             # Conception électronique (KiCad)
│   ├── circuit.kicad_sch / .kicad_pcb / .kicad_pro
│   └── gerbers/          # Fichiers de fabrication (Gerber/drill)
├── mobile-app/          # Application Flutter (code source Dart)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/      # Login, Home, Profil, Réglages
│   │   └── services/     # Authentification, communication ESP32
│   ├── assets/
│   └── pubspec.yaml
└── docs/
    └── Valise_autonome.pdf   # Rapport de projet complet
```

## 📄 Documentation complète

Le rapport de projet complet (cahier des charges, étude de l'existant, architecture, choix techniques, résultats de tests) est disponible dans [`docs/Valise_autonome.pdf`](docs/Valise_autonome.pdf).

## 🚀 Pour reproduire le firmware

1. Ouvrir `firmware/valise_autonome.ino` dans l'Arduino IDE avec le support ESP32 installé.
2. Flasher la carte ESP32.
3. Se connecter au réseau Wi-Fi `Suitcase_AP` créé par la valise.
4. Lancer l'application Flutter (`mobile-app/`) pour piloter et suivre la valise.

---

*Projet réalisé dans le cadre de la formation d'ingénieur à l'ENSEA — Molka Elloumi, [LinkedIn](https://linkedin.com/in/molkaelloumi)*
