import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/button.dart'; // Supondo que você tenha um widget de botão reutilizável
import '../widget/dialog-exclusao.dart'; // Supondo que você tenha um widget de diálogo de exclusão

class AgendaMedica extends StatefulWidget {
  const AgendaMedica({super.key});

  @override
  _AgendaMedicaState createState() => _AgendaMedicaState();
}

class _AgendaMedicaState extends State<AgendaMedica> {
  final TextEditingController _typeController = TextEditingController();
  List<String> _appointments = [];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool isEdit = false;
  int? _editedIndex;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lembrete de Consultas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      _selectedDate == null
                          ? 'Selecionar Data'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectTime(context),
                    child: Text(
                      _selectedTime == null
                          ? 'Selecionar Hora'
                          : _selectedTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Especialidade',
                hintText: 'Exemplo: Clínico Geral',
              ),
            ),
            const SizedBox(height: 20),
            buttonElevated(
              onPressed: isEdit ? _saveAppointment : _addAppointment,
              text: isEdit ? 'Salvar' : 'Adicionar',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_appointments[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editAppointment(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => dialogDelete(
                            context: context,
                            index: index,
                            onPressed: () {
                              setState(() {
                                _appointments.removeAt(index);
                                _saveAppointments();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Lembrete excluído com sucesso!'),
                                  ),
                                );
                              });
                              Navigator.of(context)
                                  .pop(); // Fechar o AlertDialog após a exclusão
                            },
                          ),
                        ),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addAppointment() {
    if (_selectedDate != null &&
        _selectedTime != null &&
        _typeController.text.isNotEmpty) {
      String date =
          '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      String time = _selectedTime!.format(context);
      String type = _typeController.text;

      setState(() {
        _appointments.add('$date $time - $type');
      });
      _typeController.clear();
      _selectedDate = null;
      _selectedTime = null;
      _saveAppointments();
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

  void _editAppointment(int index) {
    // Extrair os dados do lembrete selecionado
    String appointment = _appointments[index];
    // Dividir a string do lembrete para recuperar os valores individuais
    List<String> appointmentParts = appointment.split(' - ');

    // Preencher os campos com os valores do lembrete selecionado
    setState(() {
      isEdit = true;
      _editedIndex = index;
      _typeController.text = appointmentParts[1]; // Especialidade
      // Extrair a data e hora do lembrete para preencher _selectedDate e _selectedTime
      List<String> dateTimeParts = appointmentParts[0].split('/');
      int day = int.parse(dateTimeParts[0]);
      int month = int.parse(dateTimeParts[1]);
      int year = int.parse(dateTimeParts[2]);
      _selectedDate = DateTime(year, month, day);
      _selectedTime = TimeOfDay(
        hour: _selectedTime!.hour,
        minute: _selectedTime!.minute,
      );
    });
  }

  void _saveAppointment() {
    if (_selectedDate != null &&
        _selectedTime != null &&
        _typeController.text.isNotEmpty) {
      String date =
          '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      String time = _selectedTime!.format(context);
      String type = _typeController.text;

      setState(() {
        _appointments[_editedIndex!] = '$date $time - $type';
        isEdit = false;
        _typeController.clear();
        _selectedDate = null;
        _selectedTime = null;
      });
      _saveAppointments();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lembrete editado com sucesso!'),
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

  void _saveAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('appointments', _appointments);
  }

  void _loadAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _appointments = prefs.getStringList('appointments') ?? [];
    });
  }
}
