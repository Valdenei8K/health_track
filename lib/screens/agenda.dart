import 'package:flutter/material.dart';
import 'package:health_truck/constants_colors.dart';
import 'package:health_truck/widget/text_labels.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/button.dart';
import '../widget/default_layout.dart';
import '../widget/dialog-exclusao.dart';
import '../widget/snack_bar.dart';
import '../widget/textFormField.dart';

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
    return Layout(
      title: 'Lembrete de Consultas',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDate(context),
                    child: buttonDate(_selectedDate == null
                        ? 'Selecionar Data'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectTime(context),
                    child: buttonDate(_selectedTime == null
                        ? 'Selecionar Hora'
                        : _selectedTime!.format(context)),
                  ),
                ),
              ],
            ),
            buildText('Especialidade'),
            buildTextField(
              controller: _typeController,
              keyboardType: TextInputType.text,
              hintText: 'Exemplo: Clínico Geral',
              length: 100,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            customElevatedButton(
              context: context,
              text: isEdit ? 'Salvar' : 'Adicionar',
              onPress: isEdit ? _saveAppointment : _addAppointment,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: ColorsDefaults.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(_appointments[index], style: TextStyle(fontWeight: FontWeight.w700)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () => _editAppointment(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
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

  Container buttonDate(dynamic dateSelected) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorsDefaults.background),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      height: 44,
      child: buildText(dateSelected),
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
      SnackBarApp.success('Lembrete salvo com sucesso!');
    } else {
      SnackBarApp.error('Por favor, preencha todos os campos!');
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
      SnackBarApp.success('Lembrete editado com sucesso!');
    } else {
      SnackBarApp.error('Por favor, preencha todos os campos!');
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
