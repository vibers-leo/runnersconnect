import { View, Text, ScrollView, Pressable } from "react-native";
import { useState, useEffect } from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { Ionicons } from "@expo/vector-icons";
import Constants from "expo-constants";

const API_URL =
  Constants.expoConfig?.extra?.apiUrl ?? "https://runnersconnect.vibers.co.kr";

/* 다가오는 대회 더미 데이터 */
const UPCOMING_RACES = [
  { id: 1, name: "서울 마라톤", date: "2026-04-12", location: "서울 여의도", dDay: 13 },
  { id: 2, name: "부산 하프마라톤", date: "2026-05-03", location: "부산 해운대", dDay: 34 },
];

export default function HomeScreen() {
  const [apiStatus, setApiStatus] = useState<"loading" | "ok" | "error">("loading");

  const checkApi = async () => {
    setApiStatus("loading");
    try {
      const res = await fetch(`${API_URL}/api/v1/health`);
      setApiStatus(res.ok ? "ok" : "error");
    } catch {
      setApiStatus("error");
    }
  };

  useEffect(() => {
    checkApi();
  }, []);

  /* 카드 공통 shadow (NativeWind에서 shadow 지원 제한 → 인라인) */
  const cardShadow = {
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.06,
    shadowRadius: 12,
    elevation: 3,
  };

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1" showsVerticalScrollIndicator={false}>
        <View className="px-5 pt-4 pb-6">
          {/* 환영 메시지 */}
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-1">
            RUNNERS CONNECT
          </Text>
          <Text className="text-2xl font-bold tracking-tight text-gray-900 mb-1">
            안녕하세요, 러너! 👋
          </Text>
          <Text className="text-body text-gray-500">
            오늘도 함께 달려볼까요?
          </Text>
        </View>

        {/* 서버 연결 상태 */}
        <View className="px-5 mb-4">
          <View className="card" style={cardShadow}>
            <View className="flex-row items-center justify-between">
              <View className="flex-row items-center">
                <View
                  className={`w-2.5 h-2.5 rounded-full mr-2.5 ${
                    apiStatus === "ok"
                      ? "bg-green-500"
                      : apiStatus === "error"
                      ? "bg-red-500"
                      : "bg-yellow-500"
                  }`}
                />
                <Text className="text-body text-gray-600">
                  {apiStatus === "ok"
                    ? "서버 연결됨"
                    : apiStatus === "error"
                    ? "서버 연결 실패"
                    : "확인 중..."}
                </Text>
              </View>
              <Pressable
                onPress={checkApi}
                className="bg-primary/10 rounded-full w-9 h-9 items-center justify-center"
              >
                <Ionicons name="refresh" size={16} color="#3B82F6" />
              </Pressable>
            </View>
          </View>
        </View>

        {/* 내 기록 요약 */}
        <View className="px-5 mb-4">
          <View className="card bg-primary" style={cardShadow}>
            <Text className="text-eyebrow uppercase tracking-[0.15em] text-white/60 mb-2">
              MY RECORD
            </Text>
            <View className="flex-row items-end justify-between">
              <View>
                <Text className="text-4xl font-bold text-white tracking-tight">
                  0:00:00
                </Text>
                <Text className="text-body text-white/70 mt-1">
                  아직 기록이 없어요
                </Text>
              </View>
              <View className="bg-white/20 rounded-full w-12 h-12 items-center justify-center">
                <Ionicons name="timer-outline" size={24} color="#FFFFFF" />
              </View>
            </View>
          </View>
        </View>

        {/* 다가오는 대회 */}
        <View className="px-5 mb-4">
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-3">
            UPCOMING RACES
          </Text>
          {UPCOMING_RACES.map((race) => (
            <View key={race.id} className="card mb-3" style={cardShadow}>
              <View className="flex-row items-start justify-between">
                <View className="flex-1 mr-3">
                  <Text className="text-heading-3 text-gray-900 mb-1">
                    {race.name}
                  </Text>
                  <View className="flex-row items-center mt-1">
                    <Ionicons name="calendar-outline" size={13} color="#9CA3AF" />
                    <Text className="text-caption text-gray-400 ml-1">{race.date}</Text>
                  </View>
                  <View className="flex-row items-center mt-1">
                    <Ionicons name="location-outline" size={13} color="#9CA3AF" />
                    <Text className="text-caption text-gray-400 ml-1">{race.location}</Text>
                  </View>
                </View>
                <View className="bg-primary rounded-2xl px-3 py-1.5">
                  <Text className="text-white text-xs font-bold">D-{race.dDay}</Text>
                </View>
              </View>
            </View>
          ))}
        </View>

        {/* 빠른 메뉴 */}
        <View className="px-5 mb-8">
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-3">
            QUICK MENU
          </Text>
          <View className="flex-row gap-3">
            {[
              { icon: "trophy-outline" as const, label: "대회", color: "#3B82F6" },
              { icon: "timer-outline" as const, label: "기록", color: "#8B5CF6" },
              { icon: "people-outline" as const, label: "크루", color: "#F59E0B" },
              { icon: "stats-chart-outline" as const, label: "통계", color: "#10B981" },
            ].map((item) => (
              <View key={item.label} className="flex-1 card items-center py-5" style={cardShadow}>
                <View
                  className="w-12 h-12 rounded-full items-center justify-center mb-2"
                  style={{ backgroundColor: `${item.color}15` }}
                >
                  <Ionicons name={item.icon} size={22} color={item.color} />
                </View>
                <Text className="text-caption text-gray-600 font-semibold">{item.label}</Text>
              </View>
            ))}
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
