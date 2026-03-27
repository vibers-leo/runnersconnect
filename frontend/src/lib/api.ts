const API_URL = process.env.NEXT_PUBLIC_API_URL || "https://runnersconnect.vibers.co.kr";

interface FetchOptions extends RequestInit {
  token?: string;
}

export async function api(path: string, options: FetchOptions = {}) {
  const { token, ...fetchOptions } = options;

  const headers: Record<string, string> = {
    "Content-Type": "application/json",
    Accept: "application/json",
    ...(options.headers as Record<string, string>),
  };

  if (token) {
    headers["Authorization"] = `Bearer ${token}`;
  }

  const res = await fetch(`${API_URL}${path}`, {
    ...fetchOptions,
    headers,
  });

  if (!res.ok) {
    const error = await res.json().catch(() => ({ message: "요청에 실패했습니다" }));
    throw new Error(error.message || `API Error: ${res.status}`);
  }

  return res.json();
}

// 인증 관련
export const auth = {
  login: (email: string, password: string) =>
    api("/api/v1/auth/login", {
      method: "POST",
      body: JSON.stringify({ user: { email, password } }),
    }),

  signup: (data: { email: string; password: string; name: string }) =>
    api("/api/v1/auth/signup", {
      method: "POST",
      body: JSON.stringify({ user: data }),
    }),

  logout: (token: string) =>
    api("/api/v1/auth/logout", { method: "DELETE", token }),
};

// 대회 관련
export const races = {
  list: () => api("/api/v1/races"),
  get: (id: number) => api(`/api/v1/races/${id}`),
};

// 커뮤니티
export const communities = {
  list: () => api("/api/v1/communities"),
  get: (id: number) => api(`/api/v1/communities/${id}`),
};

// 대회 캘린더
export const calendar = {
  list: () => api("/api/v1/race_calendar"),
};

// 프로필
export const profile = {
  get: (token: string) => api("/api/v1/profile", { token }),
  update: (token: string, data: Record<string, unknown>) =>
    api("/api/v1/profile", { method: "PATCH", token, body: JSON.stringify(data) }),
};
