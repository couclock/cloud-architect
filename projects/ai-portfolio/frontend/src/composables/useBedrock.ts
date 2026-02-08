import type { PortfolioLine } from '@/api/bedrock.api.ts'
import { ref } from 'vue'
import { bedrockApi } from '@/api/bedrock.api.ts'

export function useBedrock () {
  const portfolio = ref<PortfolioLine[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function sendPrompt (prompt: string): Promise<PortfolioLine[]> {
    loading.value = true
    error.value = null
    let portfolio: PortfolioLine[] = []
    try {
      const wrapper = await bedrockApi.sendPrompt(prompt)
      portfolio = wrapper.portfolio
    } catch (error_: any) {
      error.value = error_?.message ?? 'Unknown error'
    } finally {
      loading.value = false
    }
    return portfolio
  }

  return { portfolio, loading, error, sendPrompt }
}
