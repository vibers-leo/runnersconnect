export default {
  expo: {
    name: 'RunnersConnect',
    slug: 'runnersconnect',
    scheme: 'runnersconnect',
    version: '1.0.0',
    orientation: 'portrait',
    icon: './assets/icon.png',
    userInterfaceStyle: 'light',
    newArchEnabled: false,
    splash: {
      image: './assets/splash-icon.png',
      resizeMode: 'contain',
      backgroundColor: '#FFFFFF',
    },
    ios: {
      supportsTablet: true,
      bundleIdentifier: 'com.vibers.runnersconnect',
    },
    android: {
      adaptiveIcon: {
        foregroundImage: './assets/adaptive-icon.png',
        backgroundColor: '#FFFFFF',
      },
      package: 'com.vibers.runnersconnect',
    },
    plugins: [
      'expo-router',
      'expo-font',
      'expo-secure-store',
      'expo-asset',
    ],
    extra: {
      apiUrl: 'https://runnersconnect.vibers.co.kr',
      eas: {
        projectId: '01cd1d67-9075-4b2e-8ba6-52357cb0d32e',
      },
    },
  },
};
