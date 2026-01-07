import type { SecurityInfo, SecuritySearchResult } from '@/api/security.api.ts'
import { ref } from 'vue'
import { securityApi } from '@/api/security.api.ts'

export function useSecurity () {
  const info = ref<SecurityInfo>()
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function getInfo (ticker: string) {
    loading.value = true
    error.value = null
    try {
      const wrapper = await securityApi.getInfo(ticker)
      info.value = wrapper.data
    } catch (error_: any) {
      error.value = error_?.message ?? 'Unknown error'
    } finally {
      loading.value = false
    }
  }

  async function search (query: string): Promise<SecuritySearchResult[]> {
    loading.value = true
    error.value = null
    let results: SecuritySearchResult[] = []
    try {
      results = await securityApi.search(query)
    } catch (error_: any) {
      error.value = error_?.message ?? 'Unknown error'
    } finally {
      loading.value = false
    }
    return results
  }

  return { info, loading, error, getInfo, search }
}
