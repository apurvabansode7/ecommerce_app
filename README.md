# E-Commerce Mini Application

A Flutter-based e-commerce mini app built with a clean UI and Bloc state management. The app follows a simple shopping flow:

Splash Screen → Login Screen → Dashboard → Product List → Product Details → Cart

## Features

- Splash screen with fade-in animation and auto-navigation
- Login screen with email/password validation
- Dashboard with categories from Fake Store API
- Product list by selected category
- Product details screen with price and description
- Add-to-cart functionality using Bloc
- Cart screen with quantity adjustment, remove item, and total bill
- Local cart persistence using SharedPreferences
- Checkout button placeholder

## Tech Stack

- Flutter
- Dart
- BLoC
- Fake Store API
- SharedPreferences
- Material Design UI

## App Flow

1. Splash screen appears for 3 seconds
2. User logs in with valid email and password
3. Categories are fetched from the API
4. User taps a category to view products
5. Product details open on selection
6. User adds items to cart
7. Cart updates in real time with quantity management and total calculation

## Bloc Usage

The app uses Bloc for cart state management. Cart events include:

- Add to cart
- Increase quantity
- Decrease quantity
- Remove item

This keeps the cart updates predictable and easy to manage across screens.

## API Used

Fake Store API:
- https://fakestoreapi.com/products/categories
- https://fakestoreapi.com/products/category/{category}
- https://fakestoreapi.com/products/{id}

## Setup

1. Clone the project
2. Open the folder in VS Code / Android Studio
3. Run:

```bash
flutter pub get
flutter run