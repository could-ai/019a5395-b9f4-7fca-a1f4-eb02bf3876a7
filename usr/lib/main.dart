import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const AttendancePage(),
      routes: {
        '/': (context) => const AttendancePage(),
      },
    );
  }
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<String> _students = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Eve',
  ];
  late SharedPreferences _prefs;
  final Map<String, bool> _attendance = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    _prefs = await SharedPreferences.getInstance();
    for (var student in _students) {
      final key = 'attendance_\$student';
      final value = _prefs.getBool(key) ?? false;
      _attendance[student] = value;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onAttendanceChanged(String student, bool? isPresent) {
    if (isPresent == null) return;
    setState(() {
      _attendance[student] = isPresent;
      _prefs.setBool('attendance_\$student', isPresent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Class Attendance'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return CheckboxListTile(
                  title: Text(student),
                  value: _attendance[student] ?? false,
                  onChanged: (value) => _onAttendanceChanged(student, value),
                );
              },
            ),
    );
  }
}