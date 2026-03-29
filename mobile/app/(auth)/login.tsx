import { View, Text, TextInput, Pressable, KeyboardAvoidingView, Platform } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { useState } from "react";
import { Ionicons } from "@expo/vector-icons";

/* 카드 shadow */
const cardShadow = {
  shadowColor: "#000",
  shadowOffset: { width: 0, height: 2 },
  shadowOpacity: 0.06,
  shadowRadius: 12,
  elevation: 3,
};

export default function LoginScreen() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleLogin = () => {
    // TODO: API 로그인 구현
    console.log("로그인 시도:", email);
  };

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        className="flex-1 px-5 justify-center"
      >
        {/* 로고 영역 */}
        <View className="items-center mb-10">
          <View className="w-16 h-16 bg-primary rounded-2xl items-center justify-center mb-4" style={cardShadow}>
            <Ionicons name="fitness" size={32} color="#FFFFFF" />
          </View>
          <Text className="text-2xl font-bold tracking-tight text-gray-900">
            RunnersConnect
          </Text>
          <Text className="text-body text-gray-400 mt-1">
            러너들의 커뮤니티
          </Text>
        </View>

        {/* 입력 폼 카드 */}
        <View className="card mb-6" style={cardShadow}>
          {/* 이메일 */}
          <View className="mb-4">
            <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
              EMAIL
            </Text>
            <TextInput
              value={email}
              onChangeText={setEmail}
              placeholder="email@example.com"
              placeholderTextColor="#D1D5DB"
              keyboardType="email-address"
              autoCapitalize="none"
              className="input-field"
            />
          </View>

          {/* 비밀번호 */}
          <View>
            <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
              PASSWORD
            </Text>
            <TextInput
              value={password}
              onChangeText={setPassword}
              placeholder="비밀번호를 입력하세요"
              placeholderTextColor="#D1D5DB"
              secureTextEntry
              className="input-field"
            />
          </View>
        </View>

        {/* 로그인 버튼 */}
        <Pressable onPress={handleLogin} className="btn-primary items-center" style={cardShadow}>
          <Text className="btn-primary-text">로그인</Text>
        </Pressable>

        {/* 회원가입 안내 */}
        <View className="flex-row justify-center mt-6">
          <Text className="text-body text-gray-400">계정이 없으신가요? </Text>
          <Pressable>
            <Text className="text-body text-primary font-bold">회원가입</Text>
          </Pressable>
        </View>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}
