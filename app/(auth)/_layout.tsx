import { Stack } from "expo-router";

export default function AuthLayout() {
  return (
    <Stack
      screenOptions={{
        headerShown: true,
        headerTitle: "",
        headerBackTitle: "뒤로",
        headerTintColor: "#3B82F6",
        headerStyle: { backgroundColor: "#F9FAFB" },
        headerShadowVisible: false,
      }}
    />
  );
}
