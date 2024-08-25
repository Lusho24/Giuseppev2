import 'package:flutter/material.dart';

import '../../../../../services/firebase_services.dart';
import '../../../../../utils/theme/app_colors.dart';
import '../../../common_widgets/custom_text_form_field.dart';

class CreateUserFormTab extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> usuariosFuture;

  const CreateUserFormTab({super.key, required this.usuariosFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 57.0,
              bottom: 30.0,
            ),
            child: const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 70.0,
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Text(
                  'USUARIOS',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(), //el spacer pone al otro extremo el otro objeto
                SizedBox(
                  height: 25,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserFormPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryVariantColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Añadir Usuario',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: usuariosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay usuarios disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var user = snapshot.data![index];
                      return UserCard(user: user);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3.0,
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen Usuario
            Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: const Icon(Icons.person, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['nombre'] ?? 'Nombre Usuario',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    user['telefono'] ?? 'Telefono',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    user['direccion'] ?? 'Direccion',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    user['correo'] ?? 'Correo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryVariantColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Editar',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryVariantColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Eliminar',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserFormPage extends StatelessWidget {
  const UserFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72.0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),
          child: Image.asset(
            'assets/images/logo.png',
            width: 70.0,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: _UserForm(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _UserForm extends StatefulWidget {
  const _UserForm({super.key});

  @override
  State<_UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<_UserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primaryVariantColor, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: AppColors.primaryVariantColor,
              blurRadius: 5.0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cédula', style: Theme.of(context).textTheme.bodyMedium),
                CustomTextFormField(
                  controller: _cedulaController,
                  formFieldType: FormFieldType.identity_card,
                  hintText: '1705380561',
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre', style: Theme.of(context).textTheme.bodyMedium),
                CustomTextFormField(
                  controller: _nombreController,
                  formFieldType: FormFieldType.name,
                  hintText: 'John Doe',
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contraseña',
                    style: Theme.of(context).textTheme.bodyMedium),
                CustomTextFormField(
                  controller: _claveController,
                  formFieldType: FormFieldType.password,
                  hintText: '********',
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Teléfono', style: Theme.of(context).textTheme.bodyMedium),
                CustomTextFormField(
                  controller: _telefonoController,
                  formFieldType: FormFieldType.phone,
                  hintText: '0987654321',
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dirección',
                    style: Theme.of(context).textTheme.bodyMedium),
                CustomTextFormField(
                  controller: _direccionController,
                  formFieldType: FormFieldType.address,
                  hintText: 'Calle Falsa 123',
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email', style: Theme.of(context).textTheme.bodyMedium),
                CustomTextFormField(
                  controller: _correoController,
                  formFieldType: FormFieldType.email,
                  hintText: 'correo@example.com',
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String cedula = _cedulaController.text.trim();
                  String nombre = _nombreController.text.trim();
                  String clave = _claveController.text.trim();
                  String telefono = _telefonoController.text.trim();
                  String correo = _correoController.text.trim();
                  String direccion = _direccionController.text.trim();

                  await addPersona(
                      cedula, nombre, clave, telefono, correo, direccion);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Usuario registrado con éxito')),
                  );
                },
                child: const Text('Registrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
