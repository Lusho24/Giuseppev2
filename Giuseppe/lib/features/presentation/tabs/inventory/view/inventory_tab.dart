import 'package:flutter/material.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(100.0),
      child: Text('Inventario en cosntruccion'),
    );
  }
}
