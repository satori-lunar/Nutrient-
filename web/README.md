# Nutrient Web App

A web version of the Nutrient iOS app, built with Next.js and deployed on Vercel for demonstration purposes.

## 🚀 Quick Deploy to Vercel

1. **Prerequisites:**
   - Node.js 18+
   - npm or yarn
   - Vercel account (free)

2. **Deploy:**
   ```bash
   # From the root directory
   python scripts/deploy_vercel_web.py
   ```

3. **That's it!** Your app will be live on Vercel.

## 🏗️ Architecture

- **Framework:** Next.js 14 with TypeScript
- **Styling:** Tailwind CSS
- **API:** Vercel serverless functions
- **Deployment:** Vercel (automatic scaling, CDN, SSL)

## 📱 Features

### Web-Specific Features
- **Responsive Design:** Works on desktop, tablet, and mobile
- **Fast Loading:** Optimized with Next.js
- **Serverless API:** No backend server needed

### Core Features (Same as iOS)
- **Meal Planning:** Generate and manage meal plans
- **Pantry Management:** Track ingredients and expiration dates
- **Nutrition Tracking:** Family-focused insights
- **Profile Management:** Household and preference settings

## 🛠️ Development

```bash
cd web

# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Start production server
npm start
```

## 🌐 API Routes

The web app includes serverless API routes:

- `GET /api/health` - Health check
- `GET /api/users` - Get users
- `POST /api/users` - Create user

All API routes return mock data for demonstration.

## 🎨 Customization

### Colors
Edit `tailwind.config.ts` to customize the color scheme.

### Components
Modify components in `pages/index.tsx` or create new component files.

### API
Add new API routes in `pages/api/` directory.

## 📊 Differences from iOS App

| Feature | iOS App | Web App |
|---------|---------|---------|
| **Barcode Scanning** | ✅ Native camera | ❌ Web camera API |
| **Offline Mode** | ✅ CoreData | ❌ Service workers |
| **Push Notifications** | ✅ iOS notifications | ❌ Browser notifications |
| **Native Performance** | ✅ SwiftUI | ⚠️ Web performance |
| **App Store** | ✅ Distribution | ❌ Web deployment |

## 🔄 Sync with iOS App

The web app demonstrates the same UI/UX as the iOS app, making it perfect for:
- **Design reviews**
- **User testing**
- **Stakeholder demos**
- **Marketing previews**

Both apps share the same design language and user flow.

## 🚀 Production URL

After deployment, your app will be available at:
```
https://nutrient-web.vercel.app
```

## 📝 Notes

- This is a **demonstration version** - it uses mock data
- For full functionality, deploy the FastAPI backend separately
- The web app showcases the UI/UX without native iOS features
