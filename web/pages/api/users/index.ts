import type { NextApiRequest, NextApiResponse } from 'next'

type User = {
  id: number
  email: string
  full_name: string
  is_active: boolean
}

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === 'GET') {
    // Mock data for demo
    const users: User[] = [
      {
        id: 1,
        email: 'demo@nutrient.app',
        full_name: 'Demo User',
        is_active: true
      }
    ]
    res.status(200).json(users)
  } else if (req.method === 'POST') {
    const { email, password, full_name } = req.body

    // Mock user creation
    const newUser: User = {
      id: Math.floor(Math.random() * 1000),
      email,
      full_name,
      is_active: true
    }

    res.status(200).json(newUser)
  } else {
    res.setHeader('Allow', ['GET', 'POST'])
    res.status(405).end(`Method ${req.method} Not Allowed`)
  }
}
