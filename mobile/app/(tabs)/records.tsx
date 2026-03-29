import { View, Text, ScrollView } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { Ionicons } from "@expo/vector-icons";

/* 카드 shadow */
const cardShadow = {
  shadowColor: "#000",
  shadowOffset: { width: 0, height: 2 },
  shadowOpacity: 0.06,
  shadowRadius: 12,
  elevation: 3,
};

/* 기록 더미 데이터 (빈 상태 테스트용 — 데이터 있으면 여기에 추가) */
const RECORDS: { id: number; race: string; time: string; distance: string; date: string }[] = [];

export default function RecordsScreen() {
  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1" showsVerticalScrollIndicator={false}>
        {/* 헤더 */}
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
          <View className="card bg-primary" style={cardShadow}>
            <View className="flex-row justify-between">
              <View className="items-center flex-1">
                <Text className="text-eyebrow uppercase tracking-[0.15em] text-white/60 mb-1">
                  총 대회
                </Text>
                <Text className="text-3xl font-bold text-white">{RECORDS.length}</Text>
              </View>
              <View className="w-px bg-white/20" />
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
          /* 빈 상태 */
          <View className="px-5 mt-4">
            <View className="card items-center py-16" style={cardShadow}>
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
          /* 기록 리스트 */
          <View className="px-5">
            <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-3">
              RACE HISTORY
            </Text>
            {RECORDS.map((record) => (
              <View key={record.id} className="card mb-3 flex-row items-center" style={cardShadow}>
                {/* 기록 숫자 크게 */}
                <View className="mr-4">
                  <Text className="text-2xl font-bold tracking-tight text-primary">
                    {record.time}
                  </Text>
                  <Text className="text-caption text-gray-400 mt-0.5">
                    {record.distance}
                  </Text>
                </View>
                {/* 대회명 + 날짜 */}
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
              </View>
            ))}
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}
