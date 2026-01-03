# Deployment Guide for Nutrient App

## Platform Comparison

| Platform | Backend Support | Database Support | iOS App Support | Cost | Best For |
|----------|----------------|------------------|-----------------|------|----------|
| **Vercel** | ⚠️ Limited (serverless only) | ❌ External only | ❌ Not supported | Low | Web apps |
| **Railway** | ✅ Full support | ✅ Built-in PostgreSQL | ❌ Not supported | Medium | Full-stack apps |
| **Render** | ✅ Full support | ❌ External only | ❌ Not supported | Low-Medium | APIs & web apps |
| **DigitalOcean** | ✅ Full support | ✅ Managed databases | ❌ Not supported | Medium | Scalable apps |
| **App Store** | ❌ N/A | ❌ N/A | ✅ Full support | $99/year | iOS apps |

## ❌ Why Not Vercel?

Vercel is designed for:
- **Frontend web applications** (React, Next.js, etc.)
- **Serverless functions** (API routes)
- **Static sites**

Your Nutrient app uses:
- **FastAPI backend** (traditional server, not serverless)
- **PostgreSQL database** (persistent connections)
- **iOS SwiftUI app** (native mobile, not web)

## ✅ Recommended Deployment Strategy

### 1. Backend Deployment (Railway)

Railway is perfect for your FastAPI + PostgreSQL stack:

```bash
# Install Railway CLI
npm install -g @railway/cli
railway login

# Deploy
python scripts/deploy_railway.py
```

**Railway will provide:**
- Free PostgreSQL database
- Automatic deployments from Git
- Environment variable management
- SSL certificates
- Monitoring and logs

### 2. iOS App Deployment (App Store)

```bash
# Open in Xcode
open ios/Nutrient.xcodeproj

# Follow these steps in Xcode:
# 1. Select your Apple Developer account
# 2. Configure code signing
# 3. Product > Archive
# 4. Upload to App Store Connect
# 5. Submit for review
```

### 3. Alternative: Render Deployment

If you prefer Render over Railway:

```bash
# Install Render CLI (if available)
# Or use web dashboard at render.com

# Connect your GitHub repository
# Render will auto-detect FastAPI and PostgreSQL
```

## 🚀 Quick Start Deployment

1. **Set up Railway account** at railway.app
2. **Connect your GitHub repository**
3. **Railway will automatically:**
   - Detect your Python app
   - Set up PostgreSQL database
   - Deploy your FastAPI backend
   - Provide a production URL

4. **For iOS deployment:**
   - Join Apple Developer Program ($99/year)
   - Use Xcode to archive and upload to App Store Connect
   - Wait for App Store review (usually 1-2 days)

## 🔧 Environment Configuration

### Railway Environment Variables
Set these in your Railway project settings:

```env
DATABASE_URL=postgresql://...
SECRET_KEY=your-secret-key-here
API_V1_STR=/api/v1
BACKEND_CORS_ORIGINS=https://your-ios-app-bundle-id
```

### iOS Configuration
Update your iOS API client base URL:

```swift
// In APIClient.swift
private let baseURL = URL(string: "https://your-railway-app-url.com/api/v1")!
```

## 📊 Cost Comparison

| Service | Free Tier | Paid Plans |
|---------|-----------|------------|
| **Railway** | 512MB RAM, 1GB storage | $5-10/month for basic app |
| **Render** | 750 hours/month | $7/month for web services |
| **PostgreSQL** | Included with Railway | $0 additional |
| **App Store** | N/A | $99/year developer fee |

## 🎯 Step-by-Step Deployment

### Phase 1: Backend Only
1. Deploy backend to Railway
2. Test API endpoints with Postman/curl
3. Set up database migrations

### Phase 2: iOS Testing
1. Update iOS app with production API URL
2. Test on iOS Simulator
3. Test on physical iOS device

### Phase 3: Production Launch
1. Submit iOS app to App Store
2. Set up production database
3. Configure monitoring and backups

## 🆘 Troubleshooting

### Railway Issues
- Check Railway logs in dashboard
- Verify environment variables
- Ensure Python dependencies are in requirements.txt

### iOS Issues
- Check code signing in Xcode
- Verify bundle identifier matches App Store Connect
- Test on multiple iOS versions

### Database Issues
- Run migrations: `alembic upgrade head`
- Check database connection string
- Verify PostgreSQL version compatibility

## 🔄 CI/CD Setup (Optional)

For automated deployments, connect your GitHub repository to Railway. Every push to main will trigger a new deployment.

## 📞 Support

- **Railway**: railway.app/docs
- **App Store**: developer.apple.com/support
- **FastAPI**: fastapi.tiangolo.com

---

**Bottom Line:** Use Railway for backend + App Store for iOS. Vercel won't work for your current architecture without major refactoring.
