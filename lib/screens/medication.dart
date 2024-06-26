import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationReminderApp extends StatefulWidget {
  const MedicationReminderApp({super.key});

  @override
  _MedicationReminderAppState createState() => _MedicationReminderAppState();
}

class _MedicationReminderAppState extends State<MedicationReminderApp> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _intervalController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  List<String> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
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
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Remédio',
                hintText: 'Exemplo: Tomar remédio',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _intervalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Intervalo (em horas)',
                hintText: 'Exemplo: 8',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _daysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de dias',
                hintText: 'Exemplo: 7',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addReminder,
              child: const Text('Adicionar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_reminders[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeReminder(index),
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

  void _addReminder() {
    final String type = _typeController.text;
    final String interval = _intervalController.text;
    final String days = _daysController.text;

    if (type.isNotEmpty && interval.isNotEmpty && days.isNotEmpty) {
      setState(() {
        _reminders.add(': $type, Intervalo: $interval horas, Dias: $days');
      });
      _typeController.clear();
      _intervalController.clear();
      _daysController.clear();
      _saveReminders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
        ),
      );
    }
  }

  void _removeReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
    _saveReminders();
  }

  void _saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('reminders', _reminders);
  }

  void _loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _reminders = prefs.getStringList('reminders') ?? [];
    });
  }
}
