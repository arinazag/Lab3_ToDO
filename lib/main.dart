import 'package:flutter/material.dart';
import 'screens/todo_screen.dart';

void main() => runApp(const TodoApp());

const _butter = Color(0xFFFFF3CF);
const _butterLight = Color(0xFFFFFAEA);
const _butterDeep = Color(0xFFFBE29A); 
const _brown = Color(0xFF6B4A3A); 
const _brownDark = Color(0xFF3F2A20); 
const _brownLight = Color(0xFFA78672); 
const _line = Color(0xFFE0CC9E); 
const _square = RoundedRectangleBorder();

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список задач',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _brown).copyWith(
          primary: _brown,
          onPrimary: _butterLight,
          secondaryContainer: _butterDeep,
          onSecondaryContainer: _brownDark,
          surface: _butter,
          onSurface: _brownDark,
          outline: _brownLight,
          outlineVariant: _line,
        ),
        scaffoldBackgroundColor: _butter,
        appBarTheme: const AppBarTheme(
          backgroundColor: _butter,
          foregroundColor: _brownDark,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _brown,
          foregroundColor: _butterLight,
          shape: _square,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: _butterLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: _line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: _line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: _brown, width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _brown,
            foregroundColor: _butterLight,
            shape: _square,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: _brown,
            shape: _square,
          ),
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: _butterLight,
          selectedColor: _butterDeep,
          side: BorderSide(color: _line),
          shape: _square,
          showCheckmark: false,
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            shape: const WidgetStatePropertyAll(_square),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? _butterDeep
                  : _butterLight,
            ),
            foregroundColor: const WidgetStatePropertyAll(_brownDark),
            side: const WidgetStatePropertyAll(BorderSide(color: _line)),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          shape: _square,
          side: const BorderSide(color: _brown, width: 1.5),
          checkColor: const WidgetStatePropertyAll(_butterLight),
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? _brown
                : Colors.transparent,
          ),
        ),
      ),
      builder: (context, child) => ColoredBox(
        color: _butter,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: child,
          ),
        ),
      ),
      home: const TodoScreen(),
    );
  }
}
