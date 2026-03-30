# ePay Flutter App

A mobile banking application built with Flutter, based on the ePay Figma design task.

## Features Implemented

### Authentication Flow
- **Splash Screen** – Animated logo with gradient background
- **Onboarding (3 slides)** – Swipeable intro with custom illustrations, dot indicators
- **Sign Up Screen 1** – Account creation landing with decorative illustration
- **Sign Up Screen 2** – Phone number + PIN + Re-enter PIN form
- **OTP Verification** – 4-digit OTP input with resend option
- **Login Screen** – Phone + 6-digit PIN, biometric icon, forgot PIN

### Dashboard / Home
- **Balance Card** – Balance visibility toggle (show/hide)
- **Main Services** – Cash In, Cash Out, Add Money, Send Money
- **Extra Services** – Mobile Recharge, MRT, Make Payment, Express Card Recharge
- **Pay Bill Grid** – 8 bill types (Electricity, Gas, Water, Internet, etc.)
- **Remittance** – Payoneer, PayPal, Wind, Wise
- **Side Drawer Menu** – Full ePay Menu with all items
- **Bottom Nav** – Home, QR Scan, Inbox tabs

### Transactions
- **Send Money** – Contact picker (recent + all), search, confirm screen with success dialog
- **Cash Out** – Agent/ATM toggle, partner bank list with search, confirm + success dialog
- **Add Money** – Bank to Ekpay / Card to Ekpay tabs, source selection
- **Statements** – Transaction history list with type icons and color-coded amounts

### Data Layer
- **JSON-based data** – All mock data lives in `assets/data/app_data.json`
- **AppData service** – Central data access via `AppData.user`, `.transactions`, etc.
- **Models** – Typed models: `UserModel`, `ContactModel`, `TransactionModel`, `BillModel`, etc.

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── theme/
│   └── app_theme.dart         # Colors, typography, widget themes
├── models/
│   └── models.dart            # Data models
├── data/
│   └── app_data.dart          # JSON data service
├── widgets/
│   └── common_widgets.dart    # AppButton, AppTextField, BanglaButton, etc.
└── screens/
    ├── splash_screen.dart
    ├── onboarding_screen.dart
    ├── sign_up_screen.dart
    ├── sign_up_step2_screen.dart
    ├── login_screen.dart
    ├── otp_screen.dart
    ├── home_screen.dart
    ├── side_menu.dart
    ├── send_money_screen.dart
    ├── add_money_screen.dart
    ├── cash_out_screen.dart
    └── statements_screen.dart

assets/
└── data/
    └── app_data.json          # Mock data (users, contacts, transactions, etc.)
```

## Setup & Run

### Prerequisites
- Flutter SDK >= 3.10.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode

### Steps

```bash
# 1. Clone / extract the project
cd epay_app

# 2. Install dependencies
flutter pub get

# 3. Run on device/emulator
flutter run

# 4. Build APK (Android)
flutter build apk --release

# 5. Build iOS (macOS only)
flutter build ios --release
```

## Design System

| Element | Value |
|---------|-------|
| Primary Dark | `#1A3A6B` |
| Primary Mid | `#1E4A8C` |
| Accent (Orange) | `#F5A623` |
| Success | `#27AE60` |
| Error | `#E74C3C` |
| Background | `#F8F9FB` |
| Font | Roboto (system) |

## Notes
- All data is loaded from `assets/data/app_data.json` at startup
- Navigation uses standard Flutter `Navigator` push/pop (no route package needed)
- Language toggle ("বাংলা") button is present on all auth screens — localization can be extended via Flutter's `intl` package (already in pubspec)
- Biometric login UI is shown; actual biometric auth can be added via `local_auth` package
