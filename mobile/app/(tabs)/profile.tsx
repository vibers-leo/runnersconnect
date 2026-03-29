import { View, Text, Pressable, ScrollView } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { useRouter } from "expo-router";
import { Ionicons } from "@expo/vector-icons";

/* 카드 shadow */
const cardShadow = {
  shadowColor: "#000",
  shadowOffset: { width: 0, height: 2 },
  shadowOpacity: 0.06,
  shadowRadius: 12,
  elevation: 3,
};

/* 메뉴 목록 */
const MENU_ITEMS = [
  { icon: "trophy-outline" as const, label: "내 대회", description: "참가한 대회를 확인하세요" },
  { icon: "timer-outline" as const, label: "기록 관리", description: "러닝 기록을 관리하세요" },
  { icon: "notifications-outline" as const, label: "알림 설정", description: "푸시 알림을 설정하세요" },
  { icon: "help-circle-outline" as const, label: "고객센터", description: "문의 및 도움말" },
];

export default function ProfileScreen() {
  const router = useRouter();

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1" showsVerticalScrollIndicator={false}>
        {/* 헤더 */}
        <View className="px-5 pt-4 pb-2">
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-1">
            PROFILE
          </Text>
          <Text className="text-2xl font-bold tracking-tight text-gray-900">
            프로필
          </Text>
        </View>

        {/* 아바타 + 로그인 유도 */}
        <View className="px-5 mt-4 mb-4">
          <View className="card items-center py-8" style={cardShadow}>
            <View className="w-20 h-20 bg-gray-100 rounded-full items-center justify-center mb-4">
              <Ionicons name="person" size={36} color="#D1D5DB" />
            </View>
            <Text className="text-heading-3 text-gray-900 mb-1">
              로그인이 필요합니다
            </Text>
            <Text className="text-body text-gray-400 text-center mb-6">
              로그인하고 러닝 기록을 관리하세요
            </Text>
            <Pressable
              onPress={() => router.push("/(auth)/login")}
              className="btn-primary items-center w-full"
              style={cardShadow}
            >
              <Text className="btn-primary-text">로그인</Text>
            </Pressable>
          </View>
        </View>

        {/* 메뉴 리스트 */}
        <View className="px-5 mb-4">
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-3">
            SETTINGS
          </Text>
          <View className="card" style={cardShadow}>
            {MENU_ITEMS.map((item, index) => (
              <Pressable
                key={item.label}
                className={`flex-row items-center py-4 ${
                  index < MENU_ITEMS.length - 1 ? "border-b border-gray-100" : ""
                }`}
              >
                <View className="w-10 h-10 bg-primary/10 rounded-full items-center justify-center mr-4">
                  <Ionicons name={item.icon} size={20} color="#3B82F6" />
                </View>
                <View className="flex-1">
                  <Text className="text-body font-semibold text-gray-900">
                    {item.label}
                  </Text>
                  <Text className="text-caption text-gray-400 mt-0.5">
                    {item.description}
                  </Text>
                </View>
                <Ionicons name="chevron-forward" size={18} color="#D1D5DB" />
              </Pressable>
            ))}
          </View>
        </View>

        {/* 앱 정보 */}
        <View className="items-center pb-8 mt-4">
          <Text className="text-xs text-gray-400">RunnersConnect v1.0.0</Text>
          <Text className="text-xs text-gray-300 mt-1">Powered by Vibers</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
