import { View, Text, TextInput, KeyboardAvoidingView, Platform, ScrollView } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { useState } from "react";
import { Ionicons } from "@expo/vector-icons";
import * as Haptics from "expo-haptics";
import Toast from "react-native-toast-message";
import Button from "../../components/Button";
import { TDS_ELEVATION } from "../../constants/DesignTokens";

export default function LoginScreen() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = () => {
    if (!email || !password) {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Warning);
        Toast.show({ type: 'error', text1: '입력 오류', text2: '이메일과 비밀번호를 입력해주세요' });
        return;
    }

    setLoading(true);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);

    // TODO: API 로그인 구현
    setTimeout(() => {
        setLoading(false);
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
        Toast.show({ type: 'error', text1: '로그인 실패', text2: '계정 정보를 확인해주세요' });
    }, 1500);
  };

  return (
    <SafeAreaView className="flex-1 bg-white">
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        className="flex-1"
      >
        <ScrollView className="flex-1 px-5" contentContainerStyle={{ flexGrow: 1, justifyContent: 'center' }}>
            {/* 로고 영역 */}
            <View className="items-center mb-12">
            <View className="w-20 h-20 bg-primary rounded-[28px] items-center justify-center mb-6" style={TDS_ELEVATION.fab}>
                <Ionicons name="fitness" size={40} color="#FFFFFF" />
            </View>
            <Text className="text-3xl font-bold tracking-tighter text-gray-900">
                RunnersConnect
            </Text>
            <Text className="text-body text-gray-400 mt-1">
                러너들의 커뮤니티
            </Text>
            </View>

            {/* 입력 폼 */}
            <View className="gap-5 mb-8">
                <View>
                    <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
                    EMAIL
                    </Text>
                    <TextInput
                        value={email}
                        onChangeText={setEmail}
                        placeholder="이메일을 입력하세요"
                        placeholderTextColor="#B0B8C1"
                        keyboardType="email-address"
                        autoCapitalize="none"
                        className="bg-gray-50 p-5 rounded-2xl text-body text-gray-900"
                        style={{ borderWidth: 1, borderColor: '#f3f4f6' }}
                    />
                </View>

                <View>
                    <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
                    PASSWORD
                    </Text>
                    <TextInput
                        value={password}
                        onChangeText={setPassword}
                        placeholder="비밀번호를 입력하세요"
                        placeholderTextColor="#B0B8C1"
                        secureTextEntry
                        className="bg-gray-50 p-5 rounded-2xl text-body text-gray-900"
                        style={{ borderWidth: 1, borderColor: '#f3f4f6' }}
                    />
                </View>
            </View>

            {/* 로그인 버튼 */}
            <Button
                onPress={handleLogin}
                loading={loading}
                fullWidth
                size="lg"
                haptic="medium"
                style={{ borderRadius: 9999 }}
            >
                로그인
            </Button>

            {/* 회원가입 안내 */}
            <View className="flex-row justify-center mt-8 pb-8">
            <Text className="text-body text-gray-400">계정이 없으신가요? </Text>
            <Pressable onPress={() => Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light)}>
                <Text className="text-body text-primary font-bold">회원가입</Text>
            </Pressable>
            </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}
