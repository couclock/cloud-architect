import { ref } from 'vue'
import { usersApi } from '@/api/users.api.ts'

export interface User {
  id: number | string
  name: string
  email?: string
}

export function useUsers () {
  const users = ref<User[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function fetchUsers () {
    loading.value = true
    error.value = null
    try {
      users.value = await usersApi.getAll()
    } catch (error_: any) {
      error.value = error_?.message ?? 'Unknown error'
    } finally {
      loading.value = false
    }
  }

  return { users, loading, error, fetchUsers }
}
