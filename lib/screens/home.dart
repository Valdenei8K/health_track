import 'package:flutter/material.dart';
import 'package:health_truck/constants_colors.dart';
import 'package:health_truck/screens/agenda.dart';
import 'package:health_truck/screens/imc.dart';
import '../models/home_model.dart';
import 'bula.dart';
import 'medication.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = [
    IMCCalculator(),
    MedicationReminderApp(),
    BulaApp(),
    AgendaMedica(),
    BulaApp(),
  ];

  final List<BottomNavItem> _bottomNavItems = [
    BottomNavItem(
      icon: Icons.calculate,
      label: 'Calculadora de IMC',
    ),
    BottomNavItem(
      icon: Icons.medication,
      label: 'Medicamentos',
    ),
    BottomNavItem(
      icon: Icons.search,
      label: 'BB Busca Bula',
    ),
    BottomNavItem(
      icon: Icons.calendar_today,
      label: 'Agenda',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsDefaults.background,
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems.map((item) {
          return BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(item.icon, color: ColorsDefaults.background),
            label: item.label,
          );
        }).toList(),
        backgroundColor: Colors.blueAccent,
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsDefaults.background,
        unselectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
