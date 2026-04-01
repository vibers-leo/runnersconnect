import { View, Text, ScrollView, Pressable, RefreshControl } from "react-native";
import { useState, useEffect, useCallback } from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { Ionicons } from "@expo/vector-icons";
import * as Haptics from "expo-haptics";
import Toast from "react-native-toast-message";
import Constants from "expo-constants";
import { TDS_ELEVATION } from "../../constants/DesignTokens";
import { Skeleton, SkeletonList } from "../../components/Skeleton";

const API_URL =
  Constants.expoConfig?.extra?.apiUrl ?? "https://runnersconnect.vibers.co.kr";

const UPCOMING_RACES = [
  { id: 1, name: "서울 마라톤", date: "2026-04-12", location: "서울 여의도", dDay: 13 },
  { id: 2, name: "부산 하프마라톤", date: "2026-05-03", location: "부산 해운대", dDay: 34 },
];

export default function HomeScreen() {
  const [apiStatus, setApiStatus] = useState<"loading" | "ok" | "error">("loading");
  const [refreshing, setRefreshing] = useState(false);

  const checkApi = async () => {
    setApiStatus("loading");
    try {
      const res = await fetch(`${API_URL}/api/v1/health`);
      if (res.ok) {
          setApiStatus("ok");
      } else {
          setApiStatus("error");
          Toast.show({ type: 'error', text1: '서버 연결 실패', text2: '상태 코드를 확인해주세요' });
      }
    } catch {
      setApiStatus("error");
      Toast.show({ type: 'error', text1: '네트워크 오류', text2: '서버 연결을 확인해주세요' });
    }
  };

  useEffect(() => {
    checkApi();
  }, []);

  const onRefresh = useCallback(() => {
    setRefreshing(true);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    checkApi().finally(() => setRefreshing(false));
  }, []);

  const handleQuickMenuPress = (label: string) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    Toast.show({ type: 'info', text1: label, text2: '준비 중인 기능입니다' });
  };

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView
        className="flex-1"
        showsVerticalScrollIndicator={false}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor="#3B82F6" />
        }
      >
        <View className="px-5 pt-4 pb-6">
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
          <View className="bg-white rounded-3xl p-5" style={TDS_ELEVATION.card}>
            <View className="flex-row items-center justify-between">
              <View className="flex-row items-center">
                {apiStatus === 'loading' ? (
                    <Skeleton width={10} height={10} borderRadius={5} style={{ marginRight: 10 }} />
                ) : (
                    <View
                        className={`w-2.5 h-2.5 rounded-full mr-2.5 ${
                            apiStatus === "ok" ? "bg-green-500" : "bg-red-500"
                        }`}
                    />
                )}
                {apiStatus === 'loading' ? (
                    <Skeleton width={80} height={14} />
                ) : (
                    <Text className="text-body text-gray-600">
                        {apiStatus === "ok" ? "서버 연결됨" : "서버 연결 실패"}
                    </Text>
                )}
              </View>
              <Pressable
                onPress={() => {
                  Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
                  checkApi();
                }}
                className="bg-primary/10 rounded-full w-9 h-9 items-center justify-center"
              >
                <Ionicons name="refresh" size={16} color="#3B82F6" />
              </Pressable>
            </View>
          </View>
        </View>

        {/* 내 기록 요약 */}
        <View className="px-5 mb-4">
          <View className="bg-primary rounded-3xl p-6" style={TDS_ELEVATION.card}>
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
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-3 ml-1">
            UPCOMING RACES
          </Text>
          {UPCOMING_RACES.map((race) => (
            <Pressable
                key={race.id}
                onPress={() => Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light)}
                className="bg-white rounded-3xl p-5 mb-3"
                style={TDS_ELEVATION.card}
            >
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
            </Pressable>
          ))}
        </View>

        {/* 빠른 메뉴 */}
        <View className="px-5 mb-8">
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-3 ml-1">
            QUICK MENU
          </Text>
          <View className="flex-row flex-wrap gap-3">
            {[
              { icon: "trophy-outline" as const, label: "대회", color: "#3B82F6" },
              { icon: "timer-outline" as const, label: "기록", color: "#8B5CF6" },
              { icon: "people-outline" as const, label: "크루", color: "#F59E0B" },
              { icon: "stats-chart-outline" as const, label: "통계", color: "#10B981" },
            ].map((item) => (
              <Pressable
                key={item.label}
                onPress={() => handleQuickMenuPress(item.label)}
                className="flex-1 min-w-[45%] bg-white rounded-3xl items-center py-6"
                style={TDS_ELEVATION.card}
              >
                <View
                  className="w-14 h-14 rounded-full items-center justify-center mb-3"
                  style={{ backgroundColor: `${item.color}15` }}
                >
                  <Ionicons name={item.icon} size={24} color={item.color} />
                </View>
                <Text className="text-body text-gray-800 font-bold">{item.label}</Text>
              </Pressable>
            ))}
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
