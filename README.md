# Tailor App

A production-ready Flutter mobile application connecting **Customers** with **Tailors**. Built with Clean Architecture, Riverpod, and GoRouter.

## Features

### Authentication
- Separate login & register for Customer and Tailor
- Local email & password authentication
- User role stored locally; redirect by role after login
- Forgot password, logout

### Customer
- Browse and search tailors (filter by availability)
- View tailor profile and reviews
- Place order: dress type, color, measurements, reference image, delivery date
- Save measurement profiles
- Order history and status tracking (Measuring → Cutting → Stitching → Finishing → Ready)
- Real-time chat with tailor
- Rate and review tailor

### Tailor
- View incoming orders; accept/reject
- Update order status through workflow
- Chat with customer
- Earnings summary (completed orders)
- Toggle availability (Available / Not Available)

## Tech Stack

- **Flutter** (latest stable) with null safety
- **State**: Riverpod
- **Navigation**: GoRouter
- **UI**: Material 3, responsive layout

## Project Structure (Clean Architecture)

```
lib/
├── core/
│   ├── constants/     # App constants and status enums
│   ├── router/        # GoRouter config, route names
│   └── theme/         # Material 3 light/dark theme
├── data/
│   ├── models/        # User, Order, Review, Message, MeasurementProfile
│   └── services/      # Auth, local data, Storage, Chat, notifications
├── features/
│   ├── auth/          # Role select, login, register, forgot password, providers
│   ├── customer/      # Home, tailor list/profile, place order, orders, chat, measurements
│   └── tailor/        # Home, orders, chat, earnings, availability
└── main.dart
```

## Setup

1. **Clone and install**
   ```bash
   cd "Tailor app"
   flutter pub get
   ```

2. **Local data**
   - The app uses an in-memory local store for auth, orders, reviews, chats, and measurement profiles.
   - Demo accounts are seeded for development: `customer@example.com` / `password123` and `tailor@example.com` / `password123`.

3. **Storage & notifications**
   - File uploads return local file paths.
   - Push notification hooks are currently no-ops.

4. **Run**
   ```bash
   flutter run
   ```

## Local Data Structures

- Users: id, name, email, role, phone, profileImage, createdAt, isAvailable (tailors)
- Orders: id, customerId, tailorId, dressType, color, measurements, referenceImage, deliveryDate, status, price, createdAt
- Reviews: id, customerId, tailorId, rating, comment, createdAt
- Chats: chatId from the two user ids; messages kept in local memory
- Measurement profiles: stored locally per user

## Deliverables Checklist

- [x] Clean folder structure
- [x] Models: User, Order, Review, Message, MeasurementProfile
- [x] Authentication flow with role-based redirect
- [x] Local data service (users, orders, reviews, measurement profiles)
- [x] Order management (create, accept/reject, status updates)
- [x] Chat system (chatId from two user ids, messages subcollection)
- [x] Customer UI: dashboard, tailors, profile, place order, orders, chat, measurements
- [x] Tailor UI: dashboard, orders, chat, earnings, availability
- [x] Error handling, loading states, form validation
- [x] Material 3 theme and responsive layout

## License

MIT.
