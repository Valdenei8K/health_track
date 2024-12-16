import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_truck/constants_colors.dart';
import 'package:health_truck/widget/text_labels.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/src/date_time.dart';

import '../main.dart';
import '../widget/button.dart';
import '../widget/default_layout.dart';
import '../widget/snack_bar.dart';
import '../widget/textFormField.dart';

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
              autofillHints: [AutofillHints.name],
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
                      autofillHints: [AutofillHints.name],
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
                      autofillHints: [AutofillHints.name],
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
                onPress: isEdit ? _saveEditionReminder : _addReminder,
              ),
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
                      title: Text(_reminders[index],
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            style: ButtonStyle(
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.black),
                            ),
                            onPressed: () => _editReminder(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () => _removeReminder(index),
                          )
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

  void _editReminder(int index) {
    setState(() {
      isEdit = true;
      _editedIndex = index;
      // Extrair os dados do lembrete selecionado
      String reminder = _reminders[index];
      // Dividir a string do lembrete para recuperar os valores individuais
      List<String> reminderParts = reminder.split(', ');

      // Preencher os controladores de texto com os valores do lembrete selecionado
      _typeController.text =
          reminderParts[0].substring(6); // Remove "Tipo: " do início
      _intervalController.text = reminderParts[1].substring(
          11,
          reminderParts[1].indexOf(
              ' horas')); // Remove "Intervalo: " e " horas" do início e do final
      _daysController.text =
          reminderParts[2].substring(6); // Remove "Dias: " do início
    });
  }

  void _saveEditionReminder() {
    final String type = _typeController.text;
    final String interval = _intervalController.text;
    final String days = _daysController.text;

    if (type.isNotEmpty && interval.isNotEmpty && days.isNotEmpty) {
      String editedReminder =
          'Tipo: $type, Intervalo: $interval horas, Dias: $days';
      setState(() {
        _reminders[_editedIndex!] = editedReminder;
        isEdit = false;
        _typeController.clear();
        _intervalController.clear();
        _daysController.clear();
      });
      _saveReminders();
      SnackBarApp.success("Lembrete salvo com sucesso!");
    } else {
      SnackBarApp.error("Por favor, preencha todos os campos!");
    }
  }

  void _removeReminder(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar exclusão"),
          content: Text("Tem certeza que deseja excluir este lembrete?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o AlertDialog
              },
            ),
            TextButton(
              child: Text("Excluir"),
              onPressed: () {
                setState(() {
                  _reminders.removeAt(index);
                  _saveReminders();
                  SnackBarApp.success("Lembrete excluído com sucesso!");
                });
                Navigator.of(context)
                    .pop(); // Fechar o AlertDialog após a exclusão
              },
            ),
          ],
        );
      },
    );
  }

  void _addReminder() {
    final String type = _typeController.text;
    final String interval = _intervalController.text;
    final String days = _daysController.text;
    if (type.isNotEmpty && interval.isNotEmpty && days.isNotEmpty) {
      setState(() {
        _reminders.add('Tipo: $type, Intervalo: $interval horas, Dias: $days');
        _typeController.clear();
        _intervalController.clear();
        _daysController.clear();
      });
      _saveReminders();
      SnackBarApp.success("Lembrete salvo com sucesso!");
    } else {
      SnackBarApp.error("Por favor, preencha todos os campos!");
    }
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
