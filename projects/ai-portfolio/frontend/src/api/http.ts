const BASE_URL = import.meta.env.VITE_API_BASE_URL ?? ''
const SECURITY_BASE_URL = import.meta.env.VITE_SECURITY_API_BASE_URL ?? ''

export async function http<T> (
  endpoint: string,
  options: RequestInit = {},
): Promise<T> {
  const token = localStorage.getItem('token')

  const response = await fetch(`${BASE_URL}${endpoint}`, {
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
    ...options,
  })

  if (!response.ok) {
    const message = await response.text()
    throw new Error(message || response.statusText)
  }

  return response.json() as Promise<T>
}

// Dedicated to security endpoint
export async function http2<T> (
  endpoint: string,
  options: RequestInit = {},
): Promise<T> {
  const token = localStorage.getItem('token')

  const response = await fetch(`${SECURITY_BASE_URL}${endpoint}`, {
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
    ...options,
  })

  if (!response.ok) {
    const message = await response.text()
    throw new Error(message || response.statusText)
  }

  return response.json() as Promise<T>
}
