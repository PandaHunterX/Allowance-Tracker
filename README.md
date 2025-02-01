# Pocket Wallet

![Screenshots](https://github.com/user-attachments/assets/da0e301a-6289-4c04-ab03-ba9856f8259d)

**Pocket Wallet** is a simple allowance tracker mobile application built using Flutter. It helps users efficiently manage and track their daily, weekly, or monthly allowances. This CRUD application uses SQLite for data storage.

---

## Features
- **Add Allowance:** Easily record your allowance entries.
- **View Allowance:** View a list of all your allowance transactions.
- **Update Entries:** Modify existing allowance records.
- **Delete Entries:** Remove allowance records when no longer needed.
- **User Profile:**
  - **Username:** Displays the username fetched from the database.
  - **Profile Picture:** Displays the user's profile picture, which is also fetched from the database.
  - **Settings:**
    - Change the profile picture and username.
    - Change the currency.
    - View information about the app.
- **Statistics:**
  - **Pie Graph:** Displays a pie chart of expenses or allowances by category.
- **SQLite Integration:** Persistent local storage for offline usage.
- **User-Friendly Interface:** Clean and simple UI for effortless navigation.

---

## Technologies Used
- **Framework:** Flutter
- **Database:** SQLite

### Packages Used
- `intl: ^0.20.1`: Internationalization and formatting utilities
- `uuid: ^4.5.1`: Generate unique IDs for records
- `flutter_svg: ^2.0.16`: Render SVG images in Flutter
- `sqflite: ^2.4.1`: SQLite database support
- `path: ^1.9.0`: Path manipulation utilities
- `fl_chart: ^0.69.2`: Beautiful charts for visualizing data
- `auto_size_text: ^3.0.0`: Automatically resize text to fit within bounds
- `url_launcher: ^6.3.1`: Launch URLs in the browser or external apps
- `flutter_native_splash: ^2.4.4`: Customize the native splash screen

---

## Project Structure
```
lib/
├── controllers/           // Logic controllers for the app
│   ├── allowance controllers/
│   │   ├── new_allowance.dart
│   │   └── update_allowance.dart
│   ├── data controller/
│   │   ├── delete_item.dart
│   │   └── search_bar.dart
│   ├── expense controllers/
│   │   ├── new_expense.dart
│   │   └── update_expense.dart
│   └── user controller/
│       ├── changed_profile.dart
│       └── username_form.dart
├── database/              // Database services
│   ├── database_service.dart
│   └── finance_db.dart
├── models/                // Data models
│   ├── category model/
│   │   ├── categories.dart
│   │   └── category.dart
│   ├── item model/
│   │   ├── allowance_item.dart
│   │   └── expense_item.dart
│   └── user model/
│       ├── profile_pictures_list.dart
│       └── user.dart
├── styles/                // Styling definitions
│   ├── buttons.dart
│   └── text_style.dart
├── views/                 // UI components and screens
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── search_screen.dart
│   │   ├── settings.dart
│   │   └── stats_screen.dart
│   ├── users/
│   │   ├── main_screen.dart
│   │   └── user_screen.dart
│   └── widgets/
│       ├── allowance widgets/
│       │   └── allowance_list.dart
│       ├── data widgets/
│       │   ├── empty_list.dart
│       │   └── insufficient_allowance.dart
│       ├── expenses widgets/
│       │   └── expenses_list.dart
│       ├── search widgets/
│       │   ├── date_sorting.dart
│       │   ├── empty_data.dart
│       │   └── recent_data.dart
│       ├── settings widgets/
│       │   ├── about_app.dart
│       │   ├── currency_dropdown.dart
│       │   └── help.dart
│       ├── stats widgets/
│       │   ├── pie_graph.dart
│       │   └── total_data.dart
│       └── user widgets/
│           ├── profile_picture.dart
│           ├── user_allowance.dart
│           └── username.dart
└── main.dart              // Entry point of the application
```
## Installation
To get started with Pocket Wallet, follow these steps:

1. **Download the APK:**
   - Go to the [releases section]() of this GitHub repository.
   - Click on the latest APK file to download it.
2. **Install the APK:**
   - Locate the downloaded APK file on your mobile device.
   - Tap the file to install and follow the on-screen instructions.
