import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lembrete de Consultas Médicas'),
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
                labelText: 'Tipo',
                hintText: 'Exemplo: Consulta de rotina',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addAppointment,
              child: const Text('Adicionar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_appointments[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeAppointment(index),
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
    if (_selectedDate != null && _selectedTime != null && _typeController.text.isNotEmpty) {
      String date = '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      String time = _selectedTime!.format(context);
      String type = _typeController.text;

      setState(() {
        _appointments.add('$date $time - $type');
      });
      _typeController.clear();
      _selectedDate = null;
      _selectedTime = null;
      _saveAppointments();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
        ),
      );
    }
  }

  void _removeAppointment(int index) {
    setState(() {
      _appointments.removeAt(index);
    });
    _saveAppointments();
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
