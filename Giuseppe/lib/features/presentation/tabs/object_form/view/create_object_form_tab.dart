import 'package:flutter/material.dart';
import 'package:giuseppe/features/presentation/common_widgets/custom_text_form_field.dart';
import 'package:giuseppe/utils/theme/app_colors.dart';

class CreateObjectFormTab extends StatelessWidget {
  const CreateObjectFormTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
              child: const Image(
                  image: AssetImage('assets/images/logo.png'),
                height: 75.0,
                width: double.infinity,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child:  Text('AÑADIR OBJETO', style: Theme.of(context).textTheme.titleSmall),
              ),
            ),

            Padding(padding: EdgeInsets.all(20.0), child: _NewObjectForm()),
          ],
        ),
      ),
    );
  }
}

class _NewObjectForm extends StatefulWidget {
  const _NewObjectForm({super.key});

  @override
  State<_NewObjectForm> createState() => _NewObjectFormState();
}

class _NewObjectFormState extends State<_NewObjectForm> {
  @override
  Widget build(BuildContext context) {
    String? selectedCategory;
    List<String> categories = ['Plasticos', 'Metales', 'Vidrio', 'Papel', 'Otros'];
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryVariantColor, width: 1),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryVariantColor,
            blurRadius: 5.0,
          )
        ]
      ),
      child: Form(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID', style: Theme.of(context).textTheme.bodyMedium),
                        CustomTextFormField(
                          formFieldType: FormFieldType.id,
                          hintText: '12345',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad', style: Theme.of(context).textTheme.bodyMedium),
                        CustomTextFormField(
                          formFieldType: FormFieldType.quantity,
                          hintText: '2',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre', style: Theme.of(context).textTheme.bodyMedium),
                  CustomTextFormField(
                      formFieldType: FormFieldType.name,
                      hintText: 'Nombre objeto')
                ],
              ),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descripción', style: Theme.of(context).textTheme.bodyMedium),
                  CustomTextFormField(
                      formFieldType: FormFieldType.description,
                      hintText: 'Nombre objeto')
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estado', style: Theme.of(context).textTheme.bodyMedium),
                        CustomTextFormField(
                          formFieldType: FormFieldType.status,
                          hintText: 'disponible',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Categoria', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 5.0),
                        DropdownMenu(
                          initialSelection: selectedCategory,
                          inputDecorationTheme: InputDecorationTheme(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: AppColors.primaryVariantColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          hintText: 'Seleccione una categoría',
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
                      ],
                    ),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () async {
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          )
      )
    );
  }
}
