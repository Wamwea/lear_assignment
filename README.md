# Word Cloud App

A collaborative word sharing application built with Flutter and Supabase.

## Features

- **User Authentication**: Secure sign-up and login functionality using Supabase authentication
- **Real-time Updates**: Words appear instantly across all devices when added by any user
- **Interactive Word Cloud**: Words are displayed as colorful chips that wrap around the screen
- **User-specific Actions**: Users can only delete their own words
- **Responsive Design**: Works seamlessly across different screen sizes

## Technical Implementation

### Architecture

The app follows a clean architecture approach with the following components:

- **Presentation Layer**: UI components and screens
- **Logic Layer**: State management using Riverpod
- **Service Layer**: API communication with Supabase
- **Model Layer**: Data models and entities

### Key Technologies

- **Flutter**: UI framework
- **Riverpod**: State management
- **Supabase**: Backend as a service (BaaS) for authentication and database
- **Auto Route**: Navigation management
- **RxDart**: Reactive programming

### Data Flow

1. User adds a word through the input form
2. The word is sent to Supabase database through the data service
3. Supabase real-time functionality broadcasts the change
4. The app receives the update and refreshes the word cloud

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- A Supabase account and project

### Environment Setup

1. Clone the repository
2. Create a `.env` file in the root directory with the following variables:
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```
3. Run `flutter pub get` to install dependencies
4. Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate necessary files
5. Run `flutter run` to start the application

### Supabase Configuration

**Important**: This app relies on Supabase's real-time functionality. To ensure the app works correctly:

1. Go to your Supabase project dashboard
2. Navigate to Database → Replication
3. Enable real-time for the `words` table:
   - Click on "Tables and schemas"
   - Find the `words` table
   - Enable the "Realtime" toggle

Without enabling real-time features, the app will not update automatically when words are added or deleted.

## Database Schema

The app uses a simple database schema with a single `words` table:

- `id`: Auto-incremented primary key
- `word`: The text content of the word
- `user_id`: Foreign key to the user who created the word
- `created_at`: Timestamp when the word was created