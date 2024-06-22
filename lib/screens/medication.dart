import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  runApp(const MedicationReminderApp());
}

class MedicationReminderApp extends StatelessWidget {
  const MedicationReminderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lembrete de Medicamentos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MedicationReminderScreen(),
    );
  }
}

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({Key? key}) : super(key: key);

  @override
  _MedicationReminderScreenState createState() => _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  List<String> _medications = [];
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadMedications();
    _initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembrete de Medicamentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Medicamento',
                hintText: 'Exemplo: Paracetamol',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _periodController,
              decoration: const InputDecoration(
                labelText: 'Período (em horas)',
                hintText: 'Exemplo: 8',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMedication,
              child: const Text('Adicionar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _medications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_medications[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeMedication(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addMedication() {
    String name = _nameController.text;
    String period = _periodController.text;

    if (name.isNotEmpty && period.isNotEmpty) {
      setState(() {
        _medications.add('$name - a cada $period horas');
      });
      _nameController.clear();
      _periodController.clear();
      _saveMedications();
      _scheduleNotification(name, int.parse(period));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
        ),
      );
    }
  }

  void _removeMedication(int index) {
    setState(() {
      _medications.removeAt(index);
    });
    _saveMedications();
  }

  void _saveMedications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('medications', _medications);
  }

  void _loadMedications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _medications = prefs.getStringList('medications') ?? [];
    });
  }

  void _initializeNotifications() {
    tz.initializeTimeZones();
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _localNotificationsPlugin.initialize(initializationSettings);
  }

  void _scheduleNotification(String name, int hours) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime notificationTime = now.add(Duration(hours: hours));

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    _localNotificationsPlugin.zonedSchedule(
      0,
      'Lembrete de Medicamento',
      'Hora de tomar o medicamento: $name',
      notificationTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
