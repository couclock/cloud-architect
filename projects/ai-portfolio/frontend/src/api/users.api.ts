import { http } from './http'

export interface User {
  id: number
  name: string
  email: string
}

export const usersApi = {
  getAll () {
    return http<User[]>('/users')
  },
}
