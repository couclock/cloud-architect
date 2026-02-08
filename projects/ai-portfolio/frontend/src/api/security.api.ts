import { http_security } from './http'

export interface SecurityInfo {
  shortName: string
  longName: string
  website: any
  address1: any
  city: any
  state: any
  currentPrice: number
  regularMarketChange: number
  regularMarketChangePercent: number
  regularMarketDayRange: any
  fiftyTwoWeekRange: any
  regularMarketVolume: number
  marketCap: number
  trailingPE: number
  forwardPE: number
  priceToBook: number
  enterpriseToRevenue: number
  trailingPegRatio: number
  totalRevenue: number
  netIncomeToCommon: number
  ebitda: number
  freeCashflow: number
  profitMargins: number
  dividendRate: number
  dividendYield: number
  payoutRatio: number
  lastDividendValue: number
  companyOfficers: any
  averageAnalystRating: any
  targetMeanPrice: number
  targetMedianPrice: number
  numberOfAnalystOpinions: any
  fullTimeEmployees: number
  industryDisp: any
  ebitdaMargins: number
  operatingMargins: number
  grossMargins: number
  returnOnAssets: number
  returnOnEquity: number
  totalCash: number
  totalDebt: number
  quickRatio: number
  currentRatio: number
  debtToEquity: number
  sector: string
  industry: string
}

export interface SecurityInfoWrapper {
  ticker: string
  action: string
  data: SecurityInfo
}
export interface SecuritySearchResult {
  symbol: string
  exchange: string
  shortName: string
  quoteType: string
  rank: number
}

export const securityApi = {
  getInfo (ticker: string) {
    return http_security<SecurityInfoWrapper>('/' + ticker + '/info')
  },
  search (query: string) {
    return http_security<SecuritySearchResult[]>('/search?query=' + query)
  },
}
