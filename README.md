<div align="center">

<img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android"/>
<img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
<img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
<img src="https://img.shields.io/badge/Storage-Hive-FF6900?style=for-the-badge&logo=databricks&logoColor=white" alt="Hive"/>
<img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License"/>

<br/>
<br/>

# 🔔 WakeProof

### *The alarm that knows you're actually awake.*

WakeProof is a smart Android alarm application built with Flutter. It is designed to eliminate unconscious snoozing by verifying genuine wakefulness through interactive cognitive challenges — ensuring you are truly awake before an alarm is dismissed.

</div>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [How It Works](#-how-it-works)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Roadmap](#-roadmap)
- [Permissions](#-permissions)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🧠 Overview

Most alarm apps are defeated by one behavior: **half-conscious snoozing**. WakeProof solves this by requiring the user to interact with a cognitive challenge before the alarm can be dismissed — not just tap a button in their sleep.

The app currently delivers a reliable, lightweight alarm management experience with local persistence, and is being actively developed toward full ML-powered wakefulness verification.

---

## ✨ Features

| Feature | Status | Description |
|---|---|---|
| ⏰ **Alarm Management** | ✅ Live | Add, enable/disable, and delete alarms with time-picker UI |
| 💾 **Local Persistence** | ✅ Live | Alarms saved locally on-device via Hive — survive app restarts |
| 🌗 **Dynamic Theming** | ✅ Live | Material 3 / Material You with full light & dark mode support |
| 🧩 **Cognitive Challenges** | 🚧 Planned | Randomized tasks (math, memory, pattern) before alarm dismissal |
| 🤖 **Wakefulness ML Model** | 🚧 Planned | On-device model using accelerometer + gyroscope sensor fusion |
| 📊 **Wake Quality Stats** | 🚧 Planned | Daily and weekly wakefulness quality scores |
| 🔕 **Snooze Gating** | 🚧 Planned | Snooze only available after minimum movement threshold is met |
| 🔋 **Battery-Aware Processing** | 🚧 Planned | Sensor polling scales with battery level |

---

## 🔬 How It Works

### Current Flow

```
User opens app
      │
      ▼
┌─────────────────────────────────────────┐
│           Dashboard Screen              │
│  • View all saved alarms                │
│  • Add new alarm via time picker        │
│  • Toggle alarm on/off                  │
│  • Delete alarms                        │
│  • Alarms persisted via Hive locally    │
└─────────────────────────────────────────┘
```

### Planned Flow (Roadmap)

```
Alarm triggers at scheduled time
            │
            ▼
┌───────────────────────────────────────────────────┐
│         Layer 1 — Passive Sensor Analysis          │
│                                                   │
│  Accelerometer + Gyroscope → Feature Extraction   │
│         → On-Device ML Model Inference            │
│                                                   │
│  Output: AWAKE / DROWSY / STILL classification    │
└───────────────────────────┬───────────────────────┘
                            │
              ┌─────────────┴──────────────┐
              │ AWAKE confidence > threshold│
              └─────────────┬──────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────┐
│         Layer 2 — Cognitive Challenge              │
│                                                   │
│  Randomized task presented (math / pattern /      │
│  memory sequence)                                 │
│                                                   │
│  ✓ Solved correctly → Alarm dismissed             │
│  ✗ Failed / timeout → Alarm repeats               │
└───────────────────────────────────────────────────┘
```

---

## 🏗 Architecture

WakeProof currently uses a **feature-first** folder structure, keeping alarm-related logic self-contained under `lib/features/alarm/`. The UI layer lives in `lib/screens/`.

The data layer uses **Hive** for fast, schema-typed local storage with code-generated adapters.

```
lib/
├── features/
│   └── alarm/
│       └── data/
│           ├── alarm_local_source.dart   # Hive box read/write operations
│           └── models/
│               ├── alarm_model.dart      # Hive @HiveType annotated model
│               └── alarm_model.g.dart    # Generated Hive adapter
│
├── screens/
│   └── dashboard_screen.dart             # Main UI — alarm list + add/toggle/delete
│
└── main.dart                             # App entry point — Hive init + app root
```

As the project grows toward full wakefulness verification, the architecture will expand to include domain, ML inference, sensor, and background service layers.

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.x |
| **Language** | Dart 3.x (SDK `^3.11.4`) |
| **State Management** | Flutter built-in (`StatefulWidget`, `ValueListenableBuilder`) |
| **Local Database** | Hive (`hive` + `hive_flutter`) |
| **Unique IDs** | `uuid` |
| **Code Generation** | `build_runner` + `hive_generator` |

### Planned Additions

| Layer | Technology |
|---|---|
| **On-Device ML** | TensorFlow Lite (`tflite_flutter`) |
| **Sensors** | `sensors_plus` (accelerometer, gyroscope) |
| **Background Services** | `android_alarm_manager_plus`, `flutter_background_service` |
| **Notifications** | `flutter_local_notifications` |
| **State Management** | Riverpod 2.x |
| **Navigation** | `go_router` |
| **Charts** | `fl_chart` |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android SDK `>=21` (Android 5.0 Lollipop)
- An Android device or emulator

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/wakeproof.git
cd wakeproof

# 2. Install dependencies
flutter pub get

# 3. Run Hive code generation (generates alarm_model.g.dart)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Build for release

```bash
flutter build apk --release
# or for app bundle:
flutter build appbundle --release
```

---

## 📁 Project Structure

```
wakeproof/
├── android/                          # Android-specific configuration
│   └── app/
│       └── src/main/
│           ├── AndroidManifest.xml
│           ├── java/
│           ├── kotlin/
│           └── res/
├── lib/
│   ├── main.dart                     # App entry point, Hive initialization
│   ├── features/
│   │   └── alarm/
│   │       └── data/
│   │           ├── alarm_local_source.dart   # Hive CRUD for alarms
│   │           └── models/
│   │               ├── alarm_model.dart      # Alarm data model
│   │               └── alarm_model.g.dart    # Generated Hive adapter
│   └── screens/
│       └── dashboard_screen.dart     # Main alarm list screen
├── pubspec.yaml
└── README.md
```

---

## 🗺 Roadmap

The following features are planned for future development:

- [ ] **Background alarm scheduling** — fire alarms at exact times when app is closed
- [ ] **Alarm notifications** — system notifications with alarm sound and vibration
- [ ] **Cognitive challenge screen** — math / pattern / memory tasks before dismissal
- [ ] **Sensor integration** — accelerometer & gyroscope data collection
- [ ] **On-device ML wakefulness model** — TFLite inference on IMU sensor windows
- [ ] **Snooze gating** — movement threshold before snooze is available
- [ ] **Wake quality statistics** — daily and weekly history charts
- [ ] **Alarm editor screen** — per-alarm label, sound, and challenge difficulty settings
- [ ] **State management migration** — move to Riverpod for scalability

---

## 🔐 Permissions

> **Note:** The following permissions are planned as features are implemented. The current version does not yet declare them in `AndroidManifest.xml`.

| Permission | Purpose |
|---|---|
| `USE_EXACT_ALARM` | Schedule alarms at precise times |
| `RECEIVE_BOOT_COMPLETED` | Reschedule alarms after device reboot |
| `FOREGROUND_SERVICE` | Keep alarm active while app is backgrounded |
| `BODY_SENSORS` | Access accelerometer and gyroscope |
| `VIBRATE` | Haptic feedback for alarms |
| `POST_NOTIFICATIONS` | Show alarm notifications (Android 13+) |
| `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` | Prevent OS from killing alarm service |

---

## 🧪 Testing

```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/
```

> **Note:** The test suite is currently not yet set up. Tests will be added as features are implemented.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes following [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, etc.
4. Push to your fork and open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Built with ❤️ using Flutter

*If WakeProof helped you wake up better, consider leaving a ⭐ on the repo!*

</div>
