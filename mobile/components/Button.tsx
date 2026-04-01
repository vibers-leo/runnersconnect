import React from 'react';
import { TouchableOpacity, Text, ActivityIndicator, ViewStyle, TextStyle, View } from 'react-native';
import * as Haptics from 'expo-haptics';
import { FontAwesome } from '@expo/vector-icons';
import { TDS_COLORS, TDS_ELEVATION } from '../constants/DesignTokens';

type ButtonVariant = 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger';
type ButtonSize = 'sm' | 'md' | 'lg';

interface ButtonProps {
  onPress: () => void;
  children: string | React.ReactNode;
  variant?: ButtonVariant;
  size?: ButtonSize;
  disabled?: boolean;
  loading?: boolean;
  fullWidth?: boolean;
  leftIcon?: React.ComponentProps<typeof FontAwesome>['name'];
  rightIcon?: React.ComponentProps<typeof FontAwesome>['name'];
  haptic?: 'light' | 'medium' | 'heavy' | 'success' | 'warning' | 'error' | 'none';
  style?: ViewStyle;
  textStyle?: TextStyle;
}

export default function Button({
  onPress,
  children,
  variant = 'primary',
  size = 'md',
  disabled = false,
  loading = false,
  fullWidth = false,
  leftIcon,
  rightIcon,
  haptic = 'light',
  style,
  textStyle,
}: ButtonProps) {
  const handlePress = async () => {
    if (disabled || loading) return;
    if (haptic !== 'none') triggerHaptic(haptic);
    onPress();
  };

  const { backgroundColor, textColor, borderColor, borderWidth } = getVariantStyles(variant, disabled);
  const { paddingVertical, paddingHorizontal, fontSize, iconSize } = getSizeStyles(size);

  return (
    <TouchableOpacity
      onPress={handlePress}
      disabled={disabled || loading}
      activeOpacity={0.7}
      style={[
        {
          backgroundColor,
          borderColor,
          borderWidth,
          borderRadius: 16,
          paddingVertical,
          paddingHorizontal,
          flexDirection: 'row',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 8,
          opacity: disabled ? 0.5 : 1,
        },
        fullWidth && { width: '100%' },
        variant === 'primary' && !disabled && TDS_ELEVATION.card,
        style,
      ]}
      accessibilityRole="button"
      accessibilityState={{ disabled: disabled || loading }}
    >
      {leftIcon && !loading && (
        <FontAwesome name={leftIcon} size={iconSize} color={textColor} />
      )}
      {loading && <ActivityIndicator size="small" color={textColor} />}
      {typeof children === 'string' ? (
        <Text style={[{ color: textColor, fontSize, fontWeight: '700', letterSpacing: -0.3 }, textStyle]}>
          {loading ? '처리 중...' : children}
        </Text>
      ) : (
        children
      )}
      {rightIcon && !loading && (
        <FontAwesome name={rightIcon} size={iconSize} color={textColor} />
      )}
    </TouchableOpacity>
  );
}

function getVariantStyles(variant: ButtonVariant, disabled: boolean) {
  if (disabled) return { backgroundColor: TDS_COLORS.grey200, textColor: TDS_COLORS.grey500, borderColor: 'transparent', borderWidth: 0 };
  const styles: Record<ButtonVariant, { backgroundColor: string; textColor: string; borderColor: string; borderWidth: number }> = {
    primary: { backgroundColor: TDS_COLORS.primary, textColor: TDS_COLORS.white, borderColor: 'transparent', borderWidth: 0 },
    secondary: { backgroundColor: TDS_COLORS.grey100, textColor: TDS_COLORS.grey900, borderColor: 'transparent', borderWidth: 0 },
    outline: { backgroundColor: TDS_COLORS.white, textColor: TDS_COLORS.primary, borderColor: TDS_COLORS.primary, borderWidth: 2 },
    ghost: { backgroundColor: 'transparent', textColor: TDS_COLORS.grey700, borderColor: 'transparent', borderWidth: 0 },
    danger: { backgroundColor: TDS_COLORS.red, textColor: TDS_COLORS.white, borderColor: 'transparent', borderWidth: 0 },
  };
  return styles[variant];
}

function getSizeStyles(size: ButtonSize) {
  const sizes: Record<ButtonSize, { paddingVertical: number; paddingHorizontal: number; fontSize: number; iconSize: number }> = {
    sm: { paddingVertical: 10, paddingHorizontal: 16, fontSize: 14, iconSize: 16 },
    md: { paddingVertical: 14, paddingHorizontal: 20, fontSize: 16, iconSize: 18 },
    lg: { paddingVertical: 18, paddingHorizontal: 24, fontSize: 18, iconSize: 20 },
  };
  return sizes[size];
}

function triggerHaptic(type: string) {
  try {
    switch (type) {
      case 'light': Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light); break;
      case 'medium': Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium); break;
      case 'heavy': Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Heavy); break;
      case 'success': Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success); break;
      case 'warning': Haptics.notificationAsync(Haptics.NotificationFeedbackType.Warning); break;
      case 'error': Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error); break;
      default: Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    }
  } catch {}
}
