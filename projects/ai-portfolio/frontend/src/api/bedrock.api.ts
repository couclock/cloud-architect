import { http_bedrock } from './http'

export interface PortfolioLine {
  ticker: string
  company: string
  sector: string
  investment_thesis: string
  allocation_percent: number
}
export interface Portfolio {
  portfolio: PortfolioLine[]
}

const mockData: Portfolio = {
  portfolio: [
    {
      ticker: 'OR.PA',
      company: 'Orange',
      sector: 'Telecom',
      investment_thesis: 'Strong market position in France, ongoing investments in 5G and fiber optics, and potential for diversification in cloud services and cybersecurity.',
      allocation_percent: 20,
    },
    {
      ticker: 'AI.PA',
      company: 'Airbus',
      sector: 'Aerospace & Defense',
      investment_thesis: 'Global leader in commercial and military aircraft, benefiting from post-pandemic air travel recovery, and investments in sustainable aviation technology.',
      allocation_percent: 25,
    },
    {
      ticker: 'FP.PA',
      company: 'Fargate',
      sector: 'Consumer Staples',
      investment_thesis: 'Leading French retailer with a strong brand, expanding online presence, and focus on private-label products, which could lead to consistent revenue growth.',
      allocation_percent: 20,
    },
    {
      ticker: 'EN.PA',
      company: 'Engie',
      sector: 'Energy',
      investment_thesis: 'Major player in energy services, undergoing transformation towards renewable energy, with potential for growth in energy efficiency and smart grid solutions.',
      allocation_percent: 15,
    },
    {
      ticker: 'BN.PA',
      company: ' BNP Paribas',
      sector: 'Financial Services',
      investment_thesis: 'France\'s largest bank, with a solid capital position, diversified revenue streams, and ongoing efforts to streamline operations and focus on high-margin businesses.',
      allocation_percent: 20,
    },
  ],
}

export const bedrockApi = {
  sendPrompt (prompt: string): Promise<Portfolio> {
    return http_bedrock<Portfolio>('', {
      method: 'POST',
      body: JSON.stringify({ prompt }),
    })

    //    return Promise.resolve(mockData)
  },
}
