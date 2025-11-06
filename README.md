# ANMI - Asistente Nutricional Materno Infantil (Flutter prototype)

## What this is
Minimal Flutter scaffold for the ANMI mobile app:
- Welcome screen + Consent flow
- Simple chat UI (local engine + placeholder for Gemini API)
- Data privacy controls (view / clear local chat)

This is a prototype. To run, you need Flutter SDK installed.

## Setup
1. Install Flutter: https://flutter.dev/docs/get-started/install
2. Unzip the project and open it in VS Code.
3. Copy `.env.example` to `.env` and add your GEMINI_API_KEY if you plan to connect to Gemini.
4. From project root run:
   ```bash
   flutter pub get
   flutter run
   ```

## Notes
- The `GeminiService` is a placeholder that demonstrates how you'd call an HTTP-based API.
- For ethical reasons the app prefixes responses with a disclaimer and prefers a local knowledge base first.
