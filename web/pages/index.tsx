import { useState, useEffect } from 'react'
import Head from 'next/head'
import { HomeIcon, ClipboardIcon, BookOpenIcon, ChartBarIcon, UserIcon } from '@heroicons/react/24/outline'
import { apiClient, type MealPlan, type PantryItem } from '@/lib/api'

const tabs = [
  { id: 'home', name: 'Home', icon: HomeIcon },
  { id: 'meals', name: 'Meals', icon: ClipboardIcon },
  { id: 'pantry', name: 'Pantry', icon: BookOpenIcon },
  { id: 'nutrition', name: 'Nutrition', icon: ChartBarIcon },
  { id: 'profile', name: 'Profile', icon: UserIcon },
]

export default function Home() {
  const [activeTab, setActiveTab] = useState('home')

  return (
    <div className="min-h-screen bg-gray-50">
      <Head>
        <title>Nutrient - Family Nutrition & Meal Planning</title>
        <meta name="description" content="Compassionate meal planning for busy families" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <h1 className="text-2xl font-bold text-gray-900">Nutrient</h1>
            <p className="text-sm text-gray-600">Family Nutrition & Meal Planning</p>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {activeTab === 'home' && <HomeTab />}
        {activeTab === 'meals' && <MealsTab />}
        {activeTab === 'pantry' && <PantryTab />}
        {activeTab === 'nutrition' && <NutritionTab />}
        {activeTab === 'profile' && <ProfileTab />}
      </main>

      {/* Bottom Navigation */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 md:hidden">
        <div className="grid grid-cols-5 gap-1 px-2 py-2">
          {tabs.map((tab) => {
            const Icon = tab.icon
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex flex-col items-center justify-center py-2 px-1 rounded-lg transition-colors ${
                  activeTab === tab.id
                    ? 'bg-primary-50 text-primary-600'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
              >
                <Icon className="h-5 w-5 mb-1" />
                <span className="text-xs font-medium">{tab.name}</span>
              </button>
            )
          })}
        </div>
      </nav>

      {/* Desktop Sidebar */}
      <div className="hidden md:block fixed left-0 top-20 h-full w-64 bg-white border-r border-gray-200">
        <nav className="p-4">
          <div className="space-y-2">
            {tabs.map((tab) => {
              const Icon = tab.icon
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`w-full flex items-center px-4 py-3 rounded-lg transition-colors ${
                    activeTab === tab.id
                      ? 'bg-primary-50 text-primary-600 border-r-2 border-primary-600'
                      : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                  }`}
                >
                  <Icon className="h-5 w-5 mr-3" />
                  <span className="font-medium">{tab.name}</span>
                </button>
              )
            })}
          </div>
        </nav>
      </div>

      {/* Add padding for mobile nav */}
      <div className="pb-20 md:pb-0 md:pl-64"></div>
    </div>
  )
}

function HomeTab() {
  return (
    <div className="space-y-6">
      <div className="text-center py-12">
        <h2 className="text-3xl font-bold text-gray-900 mb-4">Welcome to Nutrient</h2>
        <p className="text-xl text-gray-600 max-w-2xl mx-auto">
          Your compassionate meal planning companion that fits your real life, not the other way around.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <FeatureCard
          title="Smart Meal Planning"
          description="Plans that adapt to your schedule, budget, and family's preferences."
          icon="🍽️"
        />
        <FeatureCard
          title="Pantry Intelligence"
          description="Never waste food again with smart suggestions based on what you have."
          icon="🏪"
        />
        <FeatureCard
          title="Family-First Design"
          description="Created for busy parents who want to do their best for their family."
          icon="👨‍👩‍👧‍👦"
        />
      </div>

      <div className="card">
        <h3 className="text-lg font-semibold mb-4">Getting Started</h3>
        <div className="space-y-3">
          <Step number={1} text="Complete your household profile" />
          <Step number={2} text="Add items to your pantry" />
          <Step number={3} text="Generate your first meal plan" />
          <Step number={4} text="Enjoy stress-free family meals" />
        </div>
      </div>
    </div>
  )
}

function MealsTab() {
  const [mealPlans, setMealPlans] = useState<MealPlan[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const loadMealPlans = async () => {
      try {
        const data = await apiClient.getMealPlans()
        setMealPlans(data)
      } catch (error) {
        console.error('Failed to load meal plans:', error)
      } finally {
        setLoading(false)
      }
    }

    loadMealPlans()
  }, [])

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold">Meal Planning</h2>

      {loading ? (
        <div className="card">
          <p className="text-gray-600">Loading meal plans...</p>
        </div>
      ) : mealPlans.length > 0 ? (
        <div className="space-y-4">
          {mealPlans.map((plan) => (
            <div key={plan.id} className="card">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold">{plan.name}</h3>
                  <p className="text-gray-600">
                    {new Date(plan.start_date).toLocaleDateString()} - {new Date(plan.end_date).toLocaleDateString()}
                  </p>
                  {plan.budget_limit && plan.total_estimated_cost && (
                    <p className="text-sm text-gray-500 mt-1">
                      Budget: ${plan.total_estimated_cost.toFixed(2)} / ${plan.budget_limit.toFixed(0)}
                    </p>
                  )}
                </div>
                <button className="btn-primary text-sm">View Details</button>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="card">
          <p className="text-gray-600">No meal plans yet.</p>
          <div className="mt-4">
            <button className="btn-primary">Create Meal Plan</button>
          </div>
        </div>
      )}
    </div>
  )
}

function PantryTab() {
  const [pantryItems, setPantryItems] = useState<PantryItem[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const loadPantryItems = async () => {
      try {
        const data = await apiClient.getPantryItems()
        setPantryItems(data)
      } catch (error) {
        console.error('Failed to load pantry items:', error)
      } finally {
        setLoading(false)
      }
    }

    loadPantryItems()
  }, [])

  const getExpirationStatus = (expirationDate?: string) => {
    if (!expirationDate) return { text: 'No expiration', color: 'text-gray-500' }

    const days = Math.ceil((new Date(expirationDate).getTime() - Date.now()) / (1000 * 60 * 60 * 24))

    if (days < 0) return { text: 'Expired', color: 'text-red-600' }
    if (days === 0) return { text: 'Expires today', color: 'text-orange-600' }
    if (days === 1) return { text: 'Expires tomorrow', color: 'text-orange-600' }
    if (days <= 3) return { text: `Expires in ${days} days`, color: 'text-yellow-600' }
    return { text: `Expires in ${days} days`, color: 'text-green-600' }
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold">Your Pantry</h2>
        <div className="space-x-3">
          <button className="btn-primary">Add Item</button>
          <button className="btn-secondary">Scan Barcode</button>
        </div>
      </div>

      {loading ? (
        <div className="card">
          <p className="text-gray-600">Loading pantry items...</p>
        </div>
      ) : pantryItems.length > 0 ? (
        <div className="grid gap-4">
          {pantryItems.map((item) => {
            const expiration = getExpirationStatus(item.expiration_date)
            return (
              <div key={item.id} className="card">
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <h3 className="font-semibold">{item.name}</h3>
                    <p className="text-gray-600">
                      {item.quantity} {item.unit}
                      {item.category && ` • ${item.category}`}
                    </p>
                    <p className={`text-sm ${expiration.color}`}>
                      {expiration.text}
                    </p>
                  </div>
                  <button className="text-gray-400 hover:text-gray-600">
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
                    </svg>
                  </button>
                </div>
              </div>
            )
          })}
        </div>
      ) : (
        <div className="card text-center py-12">
          <div className="text-6xl mb-4">🏪</div>
          <h3 className="text-lg font-semibold mb-2">Your pantry is empty</h3>
          <p className="text-gray-600 mb-6">
            Add items manually or scan barcodes to start building your pantry inventory.
          </p>
          <div className="space-x-3">
            <button className="btn-primary">Add Item Manually</button>
            <button className="btn-secondary">Scan Barcode</button>
          </div>
        </div>
      )}
    </div>
  )
}

function NutritionTab() {
  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold">Nutrition Tracking</h2>
      <div className="card">
        <p className="text-gray-600">Coming soon: Compassionate nutrition tracking focused on family wellness</p>
      </div>
    </div>
  )
}

function ProfileTab() {
  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold">Your Profile</h2>
      <div className="card">
        <p className="text-gray-600">Complete your household profile to get personalized meal recommendations.</p>
        <div className="mt-4">
          <button className="btn-primary">Complete Setup</button>
        </div>
      </div>
    </div>
  )
}

function FeatureCard({ title, description, icon }: { title: string; description: string; icon: string }) {
  return (
    <div className="card">
      <div className="text-4xl mb-4">{icon}</div>
      <h3 className="text-lg font-semibold mb-2">{title}</h3>
      <p className="text-gray-600">{description}</p>
    </div>
  )
}

function Step({ number, text }: { number: number; text: string }) {
  return (
    <div className="flex items-center space-x-3">
      <div className="flex-shrink-0 w-8 h-8 bg-primary-100 text-primary-600 rounded-full flex items-center justify-center font-semibold">
        {number}
      </div>
      <p className="text-gray-700">{text}</p>
    </div>
  )
}
