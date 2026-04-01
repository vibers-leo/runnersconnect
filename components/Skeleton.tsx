import React, { useEffect } from 'react';
import { View, ViewStyle } from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withRepeat,
  withSequence,
  withTiming,
  Easing,
} from 'react-native-reanimated';
import { TDS_COLORS, TDS_RADIUS } from '../constants/DesignTokens';

interface SkeletonProps {
  width?: number | string;
  height?: number | string;
  borderRadius?: number;
  style?: ViewStyle;
}

export function Skeleton({
  width = '100%',
  height = 20,
  borderRadius = TDS_RADIUS.sm,
  style,
}: SkeletonProps) {
  const opacity = useSharedValue(0.3);

  useEffect(() => {
    opacity.value = withRepeat(
      withSequence(
        withTiming(1, { duration: 1000, easing: Easing.inOut(Easing.ease) }),
        withTiming(0.3, { duration: 1000, easing: Easing.inOut(Easing.ease) })
      ),
      -1,
      false
    );
  }, []);

  const animatedStyle = useAnimatedStyle(() => ({
    opacity: opacity.value,
  }));

  return (
    <Animated.View
      style={[
        {
          width: width as any,
          height: height as any,
          borderRadius,
          backgroundColor: TDS_COLORS.grey200,
        },
        animatedStyle,
        style,
      ]}
    />
  );
}

export function SkeletonBanner() {
  return (
    <View style={{ height: 224, marginBottom: 20 }}>
      <Skeleton width="100%" height="100%" borderRadius={0} />
    </View>
  );
}

export function SkeletonCategories() {
  return (
    <View style={{ flexDirection: 'row', paddingHorizontal: 20, marginBottom: 20, gap: 12 }}>
      {[...Array(5)].map((_, i) => (
        <View key={i} style={{ alignItems: 'center' }}>
          <Skeleton width={56} height={56} borderRadius={16} style={{ marginBottom: 6 }} />
          <Skeleton width={32} height={12} />
        </View>
      ))}
    </View>
  );
}

export function SkeletonList({ count = 3 }: { count?: number }) {
  return (
    <View style={{ paddingHorizontal: 20 }}>
      {[...Array(count)].map((_, i) => (
        <View key={i} style={{ backgroundColor: 'white', borderRadius: 24, padding: 20, marginBottom: 16 }}>
            <Skeleton width="40%" height={14} style={{ marginBottom: 12 }} />
            <Skeleton width="80%" height={24} style={{ marginBottom: 8 }} />
            <Skeleton width="60%" height={24} style={{ marginBottom: 20 }} />
            <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                <Skeleton width="30%" height={14} />
                <Skeleton width="20%" height={14} />
            </View>
        </View>
      ))}
    </View>
  );
}
