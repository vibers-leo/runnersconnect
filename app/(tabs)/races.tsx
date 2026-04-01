import { View, Text, FlatList, Pressable, RefreshControl } from "react-native";
import { useState, useEffect, useCallback } from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { Ionicons } from "@expo/vector-icons";
import * as Haptics from "expo-haptics";
import Toast from "react-native-toast-message";
import Constants from "expo-constants";
import { TDS_ELEVATION } from "../../constants/DesignTokens";
import { SkeletonList } from "../../components/Skeleton";

const API_URL =
  Constants.expoConfig?.extra?.apiUrl ?? "https://runnersconnect.vibers.co.kr";

interface Race {
  id: number;
  name: string;
  date: string;
  location: string;
  distance: string;
}

export default function RacesScreen() {
  const [races, setRaces] = useState<Race[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const fetchRaces = async () => {
    try {
      const res = await fetch(`${API_URL}/api/v1/races`);
      if (res.ok) {
        const data = await res.json();
        setRaces(data);
      } else {
        Toast.show({ type: 'error', text1: '데이터 로드 실패', text2: '대회 정보를 불러올 수 없습니다' });
      }
    } catch {
      Toast.show({ type: 'error', text1: '네트워크 오류', text2: '인터넷 연결을 확인해주세요' });
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    fetchRaces();
  }, []);

  const onRefresh = useCallback(() => {
    setRefreshing(true);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    fetchRaces();
  }, []);

  const parseDate = (dateStr: string) => {
    const d = new Date(dateStr);
    const month = d.toLocaleDateString("ko-KR", { month: "short" });
    const day = d.getDate();
    return { month, day };
  };

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <View className="px-5 pt-4 pb-2">
        <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-1">
          RACE LIST
        </Text>
        <div className="flex-row items-center justify-between">
            <Text className="text-2xl font-bold tracking-tight text-gray-900">대회</Text>
            {!loading && <View className="bg-primary/10 px-3 py-1 rounded-full"><Text className="text-primary text-caption">{races.length}건</Text></View>}
        </div>
      </View>

      {loading && !refreshing ? (
        <View className="mt-4">
            <SkeletonList count={4} />
        </View>
      ) : (
        <FlatList
          data={races}
          keyExtractor={(item) => item.id.toString()}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={{ paddingHorizontal: 20, paddingTop: 12, paddingBottom: 100 }}
          refreshControl={
            <RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor="#3B82F6" />
          }
          renderItem={({ item }) => {
            const { month, day } = parseDate(item.date);
            return (
              <Pressable
                onPress={() => Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light)}
                className="bg-white rounded-3xl p-5 mb-3 flex-row"
                style={TDS_ELEVATION.card}
              >
                <View className="bg-primary/10 rounded-2xl w-14 h-14 items-center justify-center mr-4">
                  <Text className="text-xs text-primary font-medium">{month}</Text>
                  <Text className="text-xl font-bold text-primary leading-tight">{day}</Text>
                </View>
                <View className="flex-1">
                  <Text className="text-heading-3 text-gray-900 mb-1">{item.name}</Text>
                  <View className="flex-row items-center gap-3 mt-1">
                    <View className="flex-row items-center">
                      <Ionicons name="location-outline" size={13} color="#9CA3AF" />
                      <Text className="text-caption text-gray-400 ml-1">{item.location}</Text>
                    </View>
                    <View className="bg-gray-100 px-2 py-0.5 rounded-md">
                      <Text className="text-[10px] text-gray-500 font-bold">{item.distance}</Text>
                    </View>
                  </View>
                </View>
                <View className="justify-center">
                  <Ionicons name="chevron-forward" size={18} color="#D1D5DB" />
                </View>
              </Pressable>
            );
          }}
          ListEmptyComponent={
            <View className="items-center py-20">
              <Text className="text-5xl mb-4">🏃</Text>
              <Text className="text-heading-3 text-gray-900 mb-2">등록된 대회가 없습니다</Text>
              <Text className="text-body text-gray-400 text-center">곧 새로운 대회가 등록될 예정입니다</Text>
            </View>
          }
        />
      )}
    </SafeAreaView>
  );
}
