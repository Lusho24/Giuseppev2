import 'package:flutter/material.dart';
import 'package:giuseppe/utils/theme/app_colors.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  @override
  Widget build(BuildContext context) {
    String? selectedCategory;
    List<String> categories = ['Plasticos', 'Metales', 'Vidrio', 'Papel', 'Otros'];

    //Lista de objetos del inventario:
    final List<Map<String, String>> inventoryItems = [
      {'name': 'Jarron', 'description': 'Descripción del Jarron', 'image': 'assets/images/inventario/jarron.png'},
      {'name': 'Jarron 2', 'description': 'Descripción del Jarron 2', 'image': 'assets/images/inventario/jarron2.png'},
      {'name': 'Lampara', 'description': 'Descripción de la Lampara', 'image': 'assets/images/inventario/lampara.png'},
      {'name': 'Mesa', 'description': 'Descripción de la Mesa', 'image': 'assets/images/inventario/mesa.png'},
      {'name': 'Silla', 'description': 'Descripción de la Silla', 'image': 'assets/images/inventario/silla.png'},
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(delegate: SliverChildListDelegate([
            Container(
              padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
              child: const Image(
                image: AssetImage('assets/images/logo.png'),
                width: double.infinity,
                height: 75.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('INVENTARIO', style: Theme.of(context).textTheme.titleSmall),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Buscar...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: AppColors.primaryVariantColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: DropdownMenu(
                      initialSelection: selectedCategory,
                      inputDecorationTheme: InputDecorationTheme(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: AppColors.primaryVariantColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                      hintText: 'Categoría',
                      onSelected: (String? value) {
                        setState(() {
                          selectedCategory = value;
                        });
                        print('Categoría seleccionada: $value');
                      },
                      dropdownMenuEntries: categories.map((String category) {
                        return DropdownMenuEntry<String>(
                          value: category,
                          label: category,
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ])
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 20.0 ,right: 20.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: inventoryItems.length,
                itemBuilder: (context, index) {
                  return InventoryCard(item: inventoryItems[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryCard extends StatelessWidget {
  final Map<String, String> item;
  const InventoryCard({super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              item['image']!,
              height: 60.0,
              width: double.infinity,
            ),
            SizedBox(height: 10.0),
            Text(
              item['name']!,
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Text(
                item['description']!,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

