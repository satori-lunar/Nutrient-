// Simple API client for Vercel deployment
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || '/api'

export interface User {
  id: number
  email: string
  full_name: string
  is_active: boolean
}

export interface MealPlan {
  id: number
  name: string
  start_date: string
  end_date: string
  budget_limit?: number
  total_estimated_cost?: number
}

export interface PantryItem {
  id: number
  name: string
  quantity: number
  unit: string
  expiration_date?: string
  category?: string
}

class ApiClient {
  private baseURL: string

  constructor(baseURL: string = API_BASE_URL) {
    this.baseURL = baseURL
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseURL}${endpoint}`
    const config: RequestInit = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    }

    try {
      const response = await fetch(url, config)

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      return await response.json()
    } catch (error) {
      console.error('API request failed:', error)
      throw error
    }
  }

  // Users
  async getUsers(): Promise<User[]> {
    return this.request<User[]>('/users')
  }

  async createUser(data: { email: string; password: string; full_name: string }): Promise<User> {
    return this.request<User>('/users', {
      method: 'POST',
      body: JSON.stringify(data),
    })
  }

  // Health check
  async healthCheck(): Promise<{ message: string; status: string }> {
    return this.request<{ message: string; status: string }>('/health')
  }

  // Mock data for demo
  async getMealPlans(): Promise<MealPlan[]> {
    // Return mock data for now
    return [
      {
        id: 1,
        name: 'This Week\'s Meals',
        start_date: new Date().toISOString(),
        end_date: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
        budget_limit: 100,
        total_estimated_cost: 85.50,
      }
    ]
  }

  async getPantryItems(): Promise<PantryItem[]> {
    // Return mock data for now
    return [
      {
        id: 1,
        name: 'Milk',
        quantity: 1,
        unit: 'gallon',
        expiration_date: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString(),
        category: 'Dairy',
      },
      {
        id: 2,
        name: 'Chicken Breast',
        quantity: 2,
        unit: 'lbs',
        expiration_date: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000).toISOString(),
        category: 'Meat',
      }
    ]
  }
}

export const apiClient = new ApiClient()
