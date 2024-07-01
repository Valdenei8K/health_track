import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/button.dart'; // Supondo que você tenha um widget de botão reutilizável

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembrete de Medicamentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
            buttonElevated(
              onPressed: isEdit ? _saveEditionReminder : _addReminder,
              text: (isEdit ? 'Salvar' : 'Adicionar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_reminders[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editReminder(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeReminder(index),
                        )
                      ],
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lembrete salvo com sucesso!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
        ),
      );
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lembrete excluído com sucesso!'),
                    ),
                  );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lembrete salvo com sucesso!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
        ),
      );
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
