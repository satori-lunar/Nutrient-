import type { NextApiRequest, NextApiResponse } from 'next'

type Data = {
  message: string
  status: string
}

export default function handler(
  req: NextApiRequest,
  res: NextApiResponse<Data>
) {
  res.status(200).json({
    message: 'Nutrient API is running on Vercel!',
    status: 'healthy'
  })
}
