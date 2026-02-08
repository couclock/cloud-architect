<script setup lang="ts">
  import type { PortfolioLine } from '@/api/bedrock.api'
  import type { SecurityInfo, SecuritySearchResult } from '@/api/security.api'
  import { onMounted, ref } from 'vue'
  import { useBedrock } from '@/composables/useBedrock'
  import { useSecurity } from '@/composables/useSecurity'

  const { getInfo, search } = useSecurity()
  const { portfolio, sendPrompt } = useBedrock()
  const selectedSecurity = ref<SecuritySearchResult | null>(null)
  const items = ref<SecuritySearchResult[]>([])
  const loading = ref <boolean>(false)
  const prompt = ref<string>('')
  const aiPortfolio = ref<PortfolioLine[]>([])
  const showDetailModal = ref<boolean>(false)
  const selectedTicker = ref<string>('')
  const info = ref<SecurityInfo>({} as SecurityInfo)

  async function getSecurityInfo (ticker: string) {
    if (!ticker || ticker.length === 0) {
      return
    }
    info.value = await getInfo(ticker)
  }

  async function sendNewPrompt () {
    if (prompt.value === null || prompt.value.trim().length === 0) {
      return
    }
    loading.value = true
    aiPortfolio.value = await sendPrompt(prompt.value)
    loading.value = false
  }

  function getAllocationColor (percent: number): string {
    if (percent >= 25) return 'error'
    if (percent >= 15) return 'warning'
    return 'success'
  }

  function openDetailModal (ticker: string) {
    selectedTicker.value = ticker
    showDetailModal.value = true
    getSecurityInfo(ticker)
  }

  function closeDetailModal () {
    showDetailModal.value = false
    selectedTicker.value = ''
  }

  onMounted(() => {
    // info will be fetched via getSecurityInfo
  })
</script>

<template>
  <v-container>
    <v-card>
      <v-card-title>AI Portfolio</v-card-title>
      <v-card-text>
        <v-row>
          <v-col class="text-center" cols="8">
            <v-textarea v-model="prompt" label="Let's ask to your AI Portfolio assistant" :loading="loading" />
            <v-btn color="primary" :loading="loading" variant="flat" @click="sendNewPrompt()">Give me your best portfolio</v-btn>
          </v-col>
          <v-col cols="4">
            <v-list>
              <v-list-subheader>Examples</v-list-subheader>
              <v-list-item>
                <template #prepend>
                  <v-icon icon="mdi-circle-small" />
                </template>
                You're a financial advisor and I want you to give your best stock portfolio including 5 stocks to get the best performance in next 5 years.
              </v-list-item>
              <v-list-item>
                <template #prepend>
                  <v-icon icon="mdi-circle-small" />
                </template>
                I want a long term stock portfolio in the US with the best performance in coming 10 years
              </v-list-item>
            </v-list>
          </v-col>
        </v-row>

      </v-card-text>
    </v-card>

    <!-- AI Portfolio Table -->
    <v-card v-if="aiPortfolio.length > 0" class="mt-6">
      <v-card-title>
        <v-icon class="mr-2" icon="mdi-chart-pie" />
        Your AI-Generated Portfolio
      </v-card-title>
      <v-card-text>
        <v-data-table
          class="elevation-1"
          disable-pagination
          :headers="[
            { title: 'Ticker', value: 'ticker' },
            { title: 'Company', value: 'company' },
            { title: 'Sector', value: 'sector' },
            { title: 'Allocation', value: 'allocation_percent', align: 'end' },
            { title: 'Investment Thesis', value: 'investment_thesis' },
          ]"
          hide-default-footer
          item-key="ticker"
          :items="aiPortfolio"
        >
          <template #item.company="{ item }">
            <a
              class="text-no-wrap text-decoration-none cursor-pointer"
              href="#"
              @click.prevent="openDetailModal(item.ticker)"
            >
              {{ item.company }}
            </a>
          </template>
          <template #item.sector="{ item }">
            <div class="text-no-wrap">{{ item.sector }}</div>
          </template>
          <template #item.allocation_percent="{ item }">
            <v-chip :color="getAllocationColor(item.allocation_percent)" text-color="white">
              {{ item.allocation_percent }}%
            </v-chip>
          </template>
          <template #item.investment_thesis="{ item }">
            <span class="text-wrap">{{ item.investment_thesis }}</span>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>

    <!-- Detail Modal -->
    <v-dialog v-model="showDetailModal" max-width="1200">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center">
          <span>{{ info?.longName }}</span>
          <v-btn icon="mdi-close" variant="text" @click="closeDetailModal" />
        </v-card-title>
        <v-divider />
        <v-card-text class="pa-0">
          <StockDetail :info="info" />
        </v-card-text>
      </v-card>
    </v-dialog>

  </v-container>
</template>
