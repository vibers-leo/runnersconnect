import { View, Text, ScrollView, Pressable, RefreshControl } from "react-native";
import { useState, useCallback } from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { Ionicons } from "@expo/vector-icons";
import * as Haptics from "expo-haptics";
import Toast from "react-native-toast-message";
import { TDS_ELEVATION } from "../../constants/DesignTokens";

const RECORDS: { id: number; race: string; time: string; distance: string; date: string }[] = [];

export default function RecordsScreen() {
  const [refreshing, setRefreshing] = useState(false);

  const onRefresh = useCallback(() => {
    setRefreshing(true);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    setTimeout(() => {
        setRefreshing(false);
        Toast.show({ type: 'info', text1: '기록이 업데이트되었습니다' });
    }, 1000);
  }, []);

  const handleRecordPress = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
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
        <View className="px-5 pt-4 pb-2">
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-1">
            MY RECORDS
          </Text>
          <Text className="text-2xl font-bold tracking-tight text-gray-900">
            내 기록
          </Text>
        </View>

        {/* 기록 요약 카드 */}
        <View className="px-5 mt-4 mb-4">
          <View className="bg-primary rounded-3xl p-6" style={TDS_ELEVATION.card}>
            <View className="flex-row justify-between">
              <View className="items-center flex-1">
                <Text className="text-eyebrow uppercase tracking-[0.15em] text-white/60 mb-1">
                  총 대회
                </Text>
                <Text className="text-3xl font-bold text-white">{RECORDS.length}</Text>
              </View>
              <View className="w-px bg-white/20 h-10 self-center" />
              <View className="items-center flex-1">
                <Text className="text-eyebrow uppercase tracking-[0.15em] text-white/60 mb-1">
                  베스트
                </Text>
                <Text className="text-3xl font-bold text-white">
                  {RECORDS.length > 0 ? RECORDS[0].time : "--:--"}
                </Text>
              </View>
            </View>
          </View>
        </View>

        {RECORDS.length === 0 ? (
          <View className="px-5 mt-4">
            <View className="bg-white rounded-3xl items-center py-16 px-6" style={TDS_ELEVATION.card}>
              <Text className="text-5xl mb-4">⏱</Text>
              <Text className="text-heading-3 text-gray-900 mb-2">
                아직 기록이 없습니다
              </Text>
              <Text className="text-body text-gray-400 text-center leading-relaxed">
                대회에 참가하면{"\n"}기록이 여기에 표시됩니다
              </Text>
            </View>
          </View>
        ) : (
          <View className="px-5">
            <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-3 ml-1">
              RACE HISTORY
            </Text>
            {RECORDS.map((record) => (
              <Pressable
                key={record.id}
                onPress={handleRecordPress}
                className="bg-white rounded-3xl p-5 mb-3 flex-row items-center"
                style={TDS_ELEVATION.card}
              >
                <View className="mr-4">
                  <Text className="text-2xl font-bold tracking-tight text-primary">
                    {record.time}
                  </Text>
                  <Text className="text-caption text-gray-400 mt-0.5">
                    {record.distance}
                  </Text>
                </View>
                <View className="flex-1">
                  <Text className="text-body font-semibold text-gray-900">
                    {record.race}
                  </Text>
                  <View className="flex-row items-center mt-1">
                    <Ionicons name="calendar-outline" size={12} color="#9CA3AF" />
                    <Text className="text-caption text-gray-400 ml-1">{record.date}</Text>
                  </View>
                </View>
                <Ionicons name="chevron-forward" size={18} color="#D1D5DB" />
              </Pressable>
            ))}
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}
