import { View, Text, FlatList, ActivityIndicator } from "react-native";
import { useState, useEffect } from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { Ionicons } from "@expo/vector-icons";
import Constants from "expo-constants";

const API_URL =
  Constants.expoConfig?.extra?.apiUrl ?? "https://runnersconnect.vibers.co.kr";

interface Race {
  id: number;
  name: string;
  date: string;
  location: string;
  distance: string;
}

/* 카드 shadow */
const cardShadow = {
  shadowColor: "#000",
  shadowOffset: { width: 0, height: 2 },
  shadowOpacity: 0.06,
  shadowRadius: 12,
  elevation: 3,
};

export default function RacesScreen() {
  const [races, setRaces] = useState<Race[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchRaces = async () => {
      try {
        const res = await fetch(`${API_URL}/api/v1/races`);
        if (res.ok) {
          const data = await res.json();
          setRaces(data);
        } else {
          setError("대회 정보를 불러올 수 없습니다");
        }
      } catch {
        setError("서버에 연결할 수 없습니다");
      } finally {
        setLoading(false);
      }
    };
    fetchRaces();
  }, []);

  /* 날짜에서 월/일 추출 */
  const parseDate = (dateStr: string) => {
    const d = new Date(dateStr);
    const month = d.toLocaleDateString("ko-KR", { month: "short" });
    const day = d.getDate();
    return { month, day };
  };

  if (loading) {
    return (
      <SafeAreaView className="flex-1 bg-gray-50 items-center justify-center">
        <ActivityIndicator size="large" color="#3B82F6" />
        <Text className="text-body text-gray-400 mt-3">불러오는 중...</Text>
      </SafeAreaView>
    );
  }

  if (error) {
    return (
      <SafeAreaView className="flex-1 bg-gray-50 items-center justify-center px-5">
        <Text className="text-4xl mb-4">😥</Text>
        <Text className="text-heading-3 text-gray-400 mb-2">연결 오류</Text>
        <Text className="text-body text-gray-400 text-center">{error}</Text>
      </SafeAreaView>
    );
  }

  if (races.length === 0) {
    return (
      <SafeAreaView className="flex-1 bg-gray-50 items-center justify-center px-5">
        <Text className="text-5xl mb-4">🏃</Text>
        <Text className="text-heading-3 text-gray-900 mb-2">
          등록된 대회가 없습니다
        </Text>
        <Text className="text-body text-gray-400 text-center">
          곧 새로운 대회가 등록될 예정입니다
        </Text>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      {/* 헤더 */}
      <View className="px-5 pt-4 pb-2">
        <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-1">
          RACE LIST
        </Text>
        <Text className="text-2xl font-bold tracking-tight text-gray-900">
          대회
        </Text>
      </View>

      <FlatList
        data={races}
        keyExtractor={(item) => item.id.toString()}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{ paddingHorizontal: 20, paddingTop: 12, paddingBottom: 24 }}
        renderItem={({ item }) => {
          const { month, day } = parseDate(item.date);
          return (
            <View className="race-card mb-3 flex-row" style={cardShadow}>
              {/* 날짜 뱃지 */}
              <View className="bg-primary/10 rounded-2xl w-14 h-14 items-center justify-center mr-4">
                <Text className="text-xs text-primary font-medium">{month}</Text>
                <Text className="text-xl font-bold text-primary leading-tight">{day}</Text>
              </View>
              {/* 대회 정보 */}
              <View className="flex-1">
                <Text className="text-heading-3 text-gray-900 mb-1">{item.name}</Text>
                <View className="flex-row items-center gap-3 mt-1">
                  <View className="flex-row items-center">
                    <Ionicons name="location-outline" size={13} color="#9CA3AF" />
                    <Text className="text-caption text-gray-400 ml-1">{item.location}</Text>
                  </View>
                  <View className="record-badge">
                    <Text className="record-badge-text">{item.distance}</Text>
                  </View>
                </View>
              </View>
              <View className="justify-center">
                <Ionicons name="chevron-forward" size={18} color="#D1D5DB" />
              </View>
            </View>
          );
        }}
      />
    </SafeAreaView>
  );
}
