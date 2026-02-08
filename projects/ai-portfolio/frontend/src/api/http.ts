const BASE_URL = import.meta.env.VITE_API_BASE_URL ?? ''
const SECURITY_BASE_URL = import.meta.env.VITE_SECURITY_API_BASE_URL ?? ''
const BEDROCK_BASE_URL = import.meta.env.VITE_BEDROCK_API_BASE_URL ?? ''

// Dedicated to security endpoint
export async function http_security<T> (
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

export async function http_bedrock<T> (
  endpoint: string,
  options: RequestInit = {},
): Promise<T> {
  const token = localStorage.getItem('token')

  const response = await fetch(`${BEDROCK_BASE_URL}${endpoint}`, {
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
