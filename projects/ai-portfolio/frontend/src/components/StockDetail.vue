/** **************************************************************************************************
 * Script
 */

<script setup lang="ts">

  import type { SecurityInfo } from '@/api/security.api'

  defineProps<{
    info?: SecurityInfo | null
  }>()

  function formatCurrency (value: number): string {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      minimumFractionDigits: 0,
    }).format(value)
  }

  function formatNumber (value: number): string {
    return new Intl.NumberFormat('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(value)
  }

  function formatPercent (value: number, factor = 100): string {
    return `${(value * factor).toFixed(2)}%`
  }
</script>

/** **************************************************************************************************
 * HTML Template
 */

<template>
  <v-container>
    <v-row v-if="info" class="mt-4">
      <!-- Company Info -->
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="bg-blue-lighten-5">
            <v-icon class="mr-2" icon="mdi-information" />
            Company Info
          </v-card-title>
          <v-card-text>
            <div class="mb-3">
              <strong>{{ (info as any).longName }}</strong>
              <span class="text-caption text-grey">{{ (info as any).symbol }} - {{ (info as any).sector }}</span>
            </div>
            <v-divider class="my-2" />
            <div class="text-body2">
              <p><strong>Industry:</strong> {{ info.industryDisp }}</p>
              <p><strong>Employees:</strong> {{ formatNumber(info.fullTimeEmployees) }}</p>
              <p>
                <strong>Website:</strong>
                <a href="info.website" rel="noopener" target="_blank">{{ info.website }}</a>
              </p>
              <p><strong>Address:</strong> {{ info.address1 }}, {{ info.city }}, {{ info.state }}</p>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Stock Price -->
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="bg-green-lighten-5">
            <v-icon class="mr-2" icon="mdi-chart-line" />
            Stock Price
          </v-card-title>
          <v-card-text>
            <div class="text-h5 font-weight-bold mb-2">{{ formatCurrency(info.currentPrice) }}</div>
            <div
              class="text-body1 mb-3"
              :class="{
                'text-success': info.regularMarketChange >= 0,
                'text-error': info.regularMarketChange < 0,
              }"
            >
              {{ info.regularMarketChange > 0 ? '+' : '' }}{{ formatCurrency(info.regularMarketChange) }}
              ({{ formatPercent(info.regularMarketChangePercent) }})
            </div>
            <v-divider class="my-2" />
            <div class="text-body2">
              <p><strong>Day Range:</strong> {{ info.regularMarketDayRange }}</p>
              <p><strong>52-Week Range:</strong> {{ info.fiftyTwoWeekRange }}</p>
              <p><strong>Volume:</strong> {{ formatNumber(info.regularMarketVolume) }}</p>
              <p><strong>Market Cap:</strong> {{ formatCurrency(info.marketCap) }}</p>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Valuation Metrics -->
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="bg-purple-lighten-5">
            <v-icon class="mr-2" icon="mdi-calculator" />
            Valuation Metrics
          </v-card-title>
          <v-card-text>
            <v-table density="compact">
              <tbody>
                <tr>
                  <td class="font-weight-bold">P/E Ratio (Trailing)</td>
                  <td class="text-right">{{ formatNumber(info.trailingPE) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">P/E Ratio (Forward)</td>
                  <td class="text-right">{{ formatNumber(info.forwardPE) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">P/B Ratio</td>
                  <td class="text-right">{{ formatNumber(info.priceToBook) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">EV/Revenue</td>
                  <td class="text-right">{{ formatNumber(info.enterpriseToRevenue) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">PEG Ratio</td>
                  <td class="text-right">{{ formatNumber(info.trailingPegRatio) }}</td>
                </tr>
              </tbody>
            </v-table>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Financial Metrics -->
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="bg-orange-lighten-5">
            <v-icon class="mr-2" icon="mdi-finance" />
            Financial Metrics
          </v-card-title>
          <v-card-text>
            <v-table density="compact">
              <tbody>
                <tr>
                  <td class="font-weight-bold">Revenue</td>
                  <td class="text-right">{{ formatCurrency(info.totalRevenue) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Net Income</td>
                  <td class="text-right">{{ formatCurrency(info.netIncomeToCommon) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">EBITDA</td>
                  <td class="text-right">{{ formatCurrency(info.ebitda) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Free Cash Flow</td>
                  <td class="text-right">{{ formatCurrency(info.freeCashflow) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Profit Margin</td>
                  <td class="text-right">{{ formatPercent(info.profitMargins) }}</td>
                </tr>
              </tbody>
            </v-table>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Profitability & Returns -->
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="bg-teal-lighten-5">
            <v-icon class="mr-2" icon="mdi-trending-up" />
            Profitability & Returns
          </v-card-title>
          <v-card-text>
            <v-table density="compact">
              <tbody>
                <tr>
                  <td class="font-weight-bold">ROE</td>
                  <td class="text-right">{{ formatPercent(info.returnOnEquity) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">ROA</td>
                  <td class="text-right">{{ formatPercent(info.returnOnAssets) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Gross Margin</td>
                  <td class="text-right">{{ formatPercent(info.grossMargins) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Operating Margin</td>
                  <td class="text-right">{{ formatPercent(info.operatingMargins) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">EBITDA Margin</td>
                  <td class="text-right">{{ formatPercent(info.ebitdaMargins) }}</td>
                </tr>
              </tbody>
            </v-table>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Dividend & Yield -->
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="bg-indigo-lighten-5">
            <v-icon class="mr-2" icon="mdi-percent" />
            Dividend & Yield
          </v-card-title>
          <v-card-text>
            <v-table density="compact">
              <tbody>
                <tr>
                  <td class="font-weight-bold">Dividend Rate</td>
                  <td class="text-right">{{ formatCurrency(info.dividendRate) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Dividend Yield</td>
                  <td class="text-right">{{ formatPercent(info.dividendYield, 1 ) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Payout Ratio</td>
                  <td class="text-right">{{ formatPercent(info.payoutRatio) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Last Dividend</td>
                  <td class="text-right">{{ formatCurrency(info.lastDividendValue) }}</td>
                </tr>
              </tbody>
            </v-table>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Top Management -->
      <v-col cols="12">
        <v-card>
          <v-card-title class="bg-pink-lighten-5">
            <v-icon class="mr-2" icon="mdi-account-tie" />
            Executive Team
          </v-card-title>
          <v-card-text>
            <v-table density="compact">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Title</th>
                  <th>Age</th>
                  <th class="text-right">Total Pay</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="officer in info.companyOfficers?.slice(0, 5)" :key="officer.name">
                  <td>{{ officer.name }}</td>
                  <td>{{ officer.title }}</td>
                  <td>{{ officer.age }}</td>
                  <td class="text-right">{{ formatCurrency(officer.totalPay) }}</td>
                </tr>
              </tbody>
            </v-table>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Analyst Rating -->
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="bg-cyan-lighten-5">
            <v-icon class="mr-2" icon="mdi-star" />
            Analyst Rating
          </v-card-title>
          <v-card-text>
            <div class="text-h6 font-weight-bold mb-2">{{ info.averageAnalystRating }}</div>
            <v-divider class="my-2" />
            <v-table density="compact">
              <tbody>
                <tr>
                  <td class="font-weight-bold">Target Mean Price</td>
                  <td class="text-right">{{ formatCurrency(info.targetMeanPrice) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Target Median Price</td>
                  <td class="text-right">{{ formatCurrency(info.targetMedianPrice) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold"># of Analysts</td>
                  <td class="text-right">{{ info.numberOfAnalystOpinions }}</td>
                </tr>
              </tbody>
            </v-table>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Balance Sheet -->
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="bg-lime-lighten-5">
            <v-icon class="mr-2" icon="mdi-bank" />
            Balance Sheet
          </v-card-title>
          <v-card-text>
            <v-table density="compact">
              <tbody>
                <tr>
                  <td class="font-weight-bold">Total Cash</td>
                  <td class="text-right">{{ formatCurrency(info.totalCash) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Total Debt</td>
                  <td class="text-right">{{ formatCurrency(info.totalDebt) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Debt/Equity</td>
                  <td class="text-right">{{ formatNumber(info.debtToEquity) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Current Ratio</td>
                  <td class="text-right">{{ formatNumber(info.currentRatio) }}</td>
                </tr>
                <tr>
                  <td class="font-weight-bold">Quick Ratio</td>
                  <td class="text-right">{{ formatNumber(info.quickRatio) }}</td>
                </tr>
              </tbody>
            </v-table>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <div v-else-if="!info" class="text-center mt-8">
      <p class="text-grey">Select a security to view detailed information</p>
    </div>
  </v-container>
</template>
