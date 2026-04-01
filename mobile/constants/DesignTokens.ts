/**
 * Design Tokens — 러너스커넥트 (RunnersConnect)
 * Toss Design System (TDS) 기반 프리미엄 디자인 토큰
 */

export const TDS_COLORS = {
  // Primary (러너스커넥트 블루)
  primary: '#3B82F6',
  primaryDark: '#2563EB',
  primaryLight: '#EFF6FF',

  // Grayscale
  grey900: '#191F28',
  grey800: '#333D4B',
  grey700: '#4E5968',
  grey600: '#6B7684',
  grey500: '#8B95A1',
  grey400: '#B0B8C1',
  grey300: '#D1D5DB',
  grey200: '#E5E8EB',
  grey100: '#F2F4F6',
  grey50: '#F9FAFB',

  // Semantic
  white: '#FFFFFF',
  red: '#F04452',
  success: '#2DA07A',
  warning: '#FF9500',
  error: '#F04452',
} as const;

/**
 * 타이포그래피 시스템
 */
export const TDS_TYPOGRAPHY = {
  display1: { fontSize: 26, fontWeight: 'bold' as const, letterSpacing: -0.5 },
  display2: { fontSize: 22, fontWeight: '900' as const, letterSpacing: -0.5 },
  h1: { fontSize: 20, fontWeight: 'bold' as const },
  h2: { fontSize: 18, fontWeight: 'bold' as const },
  h3: { fontSize: 16, fontWeight: 'bold' as const },
  body1: { fontSize: 15, fontWeight: '600' as const },
  body2: { fontSize: 14, fontWeight: '500' as const },
  caption1: { fontSize: 13, fontWeight: '600' as const },
  caption2: { fontSize: 12, fontWeight: 'bold' as const },
  caption3: { fontSize: 11, fontWeight: 'bold' as const },
  tiny: { fontSize: 10, fontWeight: 'bold' as const },
} as const;

/**
 * 스페이싱 시스템
 */
export const TDS_SPACING = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  '2xl': 24,
  '3xl': 32,
  '4xl': 40,
} as const;

/**
 * Border Radius 시스템
 */
export const TDS_RADIUS = {
  sm: 10,
  md: 14,
  lg: 18,
  xl: 24,
  '2xl': 28,
  '3xl': 32,
  full: 9999,
} as const;

/**
 * Elevation (Shadow) 시스템
 */
export const TDS_ELEVATION = {
  card: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.04,
    shadowRadius: 12,
    elevation: 2,
  },
  cardPressed: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.02,
    shadowRadius: 6,
    elevation: 1,
  },
  cardFloating: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.08,
    shadowRadius: 24,
    elevation: 8,
  },
  fab: {
    shadowColor: '#3B82F6',
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.3,
    shadowRadius: 12,
    elevation: 6,
  },
  none: {
    shadowColor: 'transparent',
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0,
    shadowRadius: 0,
    elevation: 0,
  },
} as const;
