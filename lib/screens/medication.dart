import 'package:flutter/material.dart';
import 'package:health_truck/constants_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/button.dart';
import '../widget/default_layout.dart';
import '../widget/snack_bar.dart';
import '../widget/textFormField.dart';
import '../widget/text_labels.dart';

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
  bool isEdit = false;
  int? _editedIndex;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Lembrete de Medicamentos',
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText('Nome do Remédio'),
            textForm(
              textInputAction: TextInputAction.next,
              controller: _typeController,
              maxLength: 20,
              textInputType: TextInputType.text,
              obscureText: false,
              hintText: 'Exemplo: Tomar remédio',
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText('Intervalo (em horas)'),
                    textForm(
                      textInputAction: TextInputAction.next,
                      controller: _intervalController,
                      maxLength: 2,
                      textInputType: TextInputType.number,
                      obscureText: false,
                      hintText: 'Exemplo: 8',
                    ),
                  ],
                )),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText('Número de dias'),
                    textForm(
                      textInputAction: TextInputAction.done,
                      maxLength: 2,
                      controller: _daysController,
                      textInputType: TextInputType.number,
                      obscureText: false,
                      hintText: 'Exemplo: 7',
                    ),
                  ],
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: customElevatedButton(
                  context: context,
                  text: isEdit ? 'Salvar' : 'Adicionar',
                  onPress: _addReminder),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: ColorsDefaults.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _reminders[index]
                            .split('\n') // Divide as linhas do lembrete
                            .map((line) => Text(
                                  line,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ))
                            .toList(),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // IconButton(
                          //   icon: const Icon(Icons.edit, color: Colors.blue),
                          //   onPressed: () => _editReminder(index),
                          // ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeReminder(index),
                          ),
                        ],
                      ),
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
    final int? interval = int.tryParse(_intervalController.text);
    final int? days = int.tryParse(_daysController.text);

    if (type.isNotEmpty && interval != null && days != null) {
      final List<DateTime> schedule = _generateSchedule(interval, days);
      final String formattedSchedule = schedule
          .map((date) =>
              "${date.day}/${date.month} às ${date.hour}:${date.minute.toString().padLeft(2, '0')}")
          .join('\n'); // Use '\n' para separar os horários por linha

      setState(() {
        _reminders.add(
          'Nome do remédio: $type\nIntervalo: $interval horas\nNúmero de dias: $days\nHorários: $formattedSchedule',
        );
        _typeController.clear();
        _intervalController.clear();
        _daysController.clear();
      });
      _saveReminders();
      SnackBarApp.success("Lembrete salvo com sucesso!");
    } else {
      SnackBarApp.error("Por favor, preencha todos os campos corretamente!");
    }
  }

  List<DateTime> _generateSchedule(int interval, int days) {
    final List<DateTime> schedule = [];
    DateTime startTime = DateTime.now();
    final int totalHours = days * 24;

    for (int hour = 0; hour < totalHours; hour += interval) {
      schedule.add(startTime.add(Duration(hours: hour)));
    }
    return schedule;
  }

  void _removeReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
    _saveReminders();
    SnackBarApp.success("Lembrete excluído com sucesso!");
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
