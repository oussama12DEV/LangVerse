import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006878),
      surfaceTint: Color(4278216824),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289261055),
      onPrimaryContainer: Color(4278198053),
      secondary: Color(4283130472),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291684334),
      onSecondaryContainer: Color(4278525732),
      tertiary: Color(4283784574),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4292665855),
      onTertiaryContainer: Color(4279376439),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294310652),
      onSurface: Color(4279704862),
      onSurfaceVariant: Color(4282337355),
      outline: Color(4285495675),
      outlineVariant: Color(4290758859),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inversePrimary: Color(4286894821),
      primaryFixed: Color(4289261055),
      onPrimaryFixed: Color(4278198053),
      primaryFixedDim: Color(4286894821),
      onPrimaryFixedVariant: Color(4278210139),
      secondaryFixed: Color(4291684334),
      onSecondaryFixed: Color(4278525732),
      secondaryFixedDim: Color(4289907666),
      onSecondaryFixedVariant: Color(4281551440),
      tertiaryFixed: Color(4292665855),
      onTertiaryFixed: Color(4279376439),
      tertiaryFixedDim: Color(4290692587),
      onTertiaryFixedVariant: Color(4282271077),
      surfaceDim: Color(4292205533),
      surfaceBright: Color(4294310652),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293915894),
      surfaceContainer: Color(4293521393),
      surfaceContainerHigh: Color(4293192171),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4286894821),
      surfaceTint: Color(4286894821),
      onPrimary: Color(4278203967),
      primaryContainer: Color(4278210139),
      onPrimaryContainer: Color(4289261055),
      secondary: Color(4289907666),
      onSecondary: Color(4280038457),
      secondaryContainer: Color(4281551440),
      onSecondaryContainer: Color(4291684334),
      tertiary: Color(4290692587),
      onTertiary: Color(4280758093),
      tertiaryContainer: Color(4282271077),
      onTertiaryContainer: Color(4292665855),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279178262),
      onSurface: Color(4292797413),
      onSurfaceVariant: Color(4290758859),
      outline: Color(4287206037),
      outlineVariant: Color(4282337355),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inversePrimary: Color(4278216824),
      primaryFixed: Color(4289261055),
      onPrimaryFixed: Color(4278198053),
      primaryFixedDim: Color(4286894821),
      onPrimaryFixedVariant: Color(4278210139),
      secondaryFixed: Color(4291684334),
      onSecondaryFixed: Color(4278525732),
      secondaryFixedDim: Color(4289907666),
      onSecondaryFixedVariant: Color(4281551440),
      tertiaryFixed: Color(4292665855),
      onTertiaryFixed: Color(4279376439),
      tertiaryFixedDim: Color(4290692587),
      onTertiaryFixedVariant: Color(4282271077),
      surfaceDim: Color(4279178262),
      surfaceBright: Color(4281612860),
      surfaceContainerLowest: Color(4278783761),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily dark;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.dark,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
