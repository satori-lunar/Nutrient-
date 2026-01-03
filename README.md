# Nutrient - Lifestyle-Aware Family Nutrition App

A compassionate mobile application that adapts to users' actual circumstances—budget, time, energy, location, culture, and family dynamics—rather than forcing users to conform to unrealistic standards.

## Features

### Core Features
- **Comprehensive Onboarding**: Household composition, location, budget, time/energy assessment, cultural background, and preferences
- **Intelligent Meal Planning**: Budget-aware, pantry-based meal suggestions with cultural relevance
- **Pantry Management**: Manual entry and barcode scanning with expiration tracking
- **Location-Aware Grocery Intelligence**: Store-specific pricing and bulk purchase recommendations
- **Compassionate Nutrition Tracking**: Family-level insights without judgment

### Design Principles
- Supportive, non-judgmental language
- "Burnout mode" options for low-energy days
- Calm visual design that reduces cognitive load
- No shame-based features or rigid requirements

## Architecture

### Backend (Python/FastAPI)
- **Framework**: FastAPI with async support
- **Database**: PostgreSQL with SQLAlchemy ORM
- **Authentication**: JWT tokens with bcrypt password hashing
- **External APIs**: Grocery store APIs, barcode lookup services

### Mobile App (iOS/SwiftUI)
- **Framework**: SwiftUI for modern, responsive UI
- **Offline Support**: CoreData for local data storage
- **Barcode Scanning**: AVFoundation for camera integration
- **State Management**: ObservableObject pattern

## Setup

### Backend Setup

1. Install Python dependencies:
```bash
cd backend
pip install -r requirements.txt
```

2. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your database and API credentials
```

3. Run the backend server:
```bash
python scripts/run_backend.py
```

### iOS App Setup

1. Open `ios/Nutrient.xcodeproj` in Xcode
2. Select your development team
3. Build and run on simulator or device

## Deployment

### 🚀 Quick Demo on Vercel (See Your App Now!)

Want to see your app **live right now**? Deploy the web version in 5 minutes:

```bash
# One-command deployment to Vercel
python scripts/deploy_vercel_web.py
```

**Instant Results:**
- ✅ Live web app with your exact UI/UX
- ✅ Responsive design (works on phone/desktop)
- ✅ Free hosting on Vercel
- ✅ Shareable URL for demos/testing
- ✅ Same look/feel as iOS app

**Perfect for:**
- Design reviews
- User testing
- Stakeholder demos
- Quick previews

### 📱 Production Deployment

#### Option 1: Full Production Stack (Recommended)
- **Backend:** Railway or Render (FastAPI + PostgreSQL)
- **iOS App:** App Store (native SwiftUI app)

```bash
# Backend deployment
python scripts/deploy_railway.py

# iOS deployment (requires Xcode + macOS)
open ios/Nutrient.xcodeproj
```

#### Option 2: Web App Only
For a web-only version with real functionality:

```bash
# Deploy web frontend to Vercel
cd web && vercel

# Note: Requires converting FastAPI backend to Vercel serverless functions
```

### Full Deployment Guide
See [docs/DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md) for detailed instructions.

### Development Setup

```bash
# Backend (Python)
cd backend
pip install -r requirements.txt
python scripts/run_backend.py

# Web Demo (Next.js)
cd web
npm install
npm run dev

# iOS App (requires macOS + Xcode)
open ios/Nutrient.xcodeproj
```

## Development

### Project Structure

```
├── backend/                 # Python FastAPI backend
│   ├── app/
│   │   ├── api/            # API endpoints
│   │   ├── core/           # Core functionality (config, security)
│   │   ├── crud/           # Database operations
│   │   ├── db/             # Database setup and models
│   │   ├── models/         # SQLAlchemy models
│   │   └── schemas/        # Pydantic schemas
│   ├── requirements.txt
│   └── main.py
├── ios/                     # iOS SwiftUI app (native)
│   ├── Nutrient/
│   │   ├── Models/         # Data models
│   │   ├── Views/          # SwiftUI views
│   │   ├── Services/       # API client and services
│   │   └── App/            # App entry point
├── web/                     # Next.js web app (Vercel demo)
│   ├── pages/              # Next.js pages and API routes
│   ├── lib/                # API client and utilities
│   ├── styles/             # Global styles
│   ├── package.json
│   └── vercel.json         # Vercel configuration
├── docs/                    # Documentation
└── scripts/                 # Build and deployment scripts
```

## API Documentation

When running the backend server, visit `http://localhost:8000/docs` for interactive API documentation.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
