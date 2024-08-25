import 'package:flutter/material.dart';

// Rutas de las tabs
import 'package:giuseppe/features/presentation/tabs/inventory/view/inventory_tab.dart';
import 'package:giuseppe/features/presentation/tabs/object_form/view/create_object_form_tab.dart';
import 'package:giuseppe/features/presentation/tabs/user_form/view/create_user_form_tab.dart';

import '../../../../services/firebase_services.dart';


class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedItemIndex = 0;
  final List<Widget> _tabsOptions = [
    const InventoryTab(),
    const CreateObjectFormTab(),
    CreateUserFormTab(usuariosFuture: getPersonas()),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedItemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabsOptions.elementAt(_selectedItemIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedItemIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_sharp),
              label: 'Inventario'),
          NavigationDestination(
              icon: Icon(Icons.add_sharp),
              label: 'Añadir Objeto'),
          NavigationDestination(
              icon: Icon(Icons.person_add_alt_1_outlined),
              selectedIcon: Icon(Icons.person_add_alt_1_sharp),
              label: 'Usuarios')
        ],
      ),

    );
  }
}
