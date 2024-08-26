import 'package:flutter/material.dart';
import '../../../../../services/firebase_services.dart';
import '../../../../../utils/theme/app_colors.dart';
import '../../../common_widgets/custom_text_form_field.dart';

class CreateUserFormTab extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> usuariosFuture;

  const CreateUserFormTab({super.key, required this.usuariosFuture});

  @override
  _CreateUserFormTabState createState() => _CreateUserFormTabState();
}

class _CreateUserFormTabState extends State<CreateUserFormTab> {
  late Future<List<Map<String, dynamic>>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = widget.usuariosFuture;
  }

  Future<void> _refreshUsuarios() async {
    setState(() {
      _usuariosFuture = getPersonas();
    });
  }

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
                const Spacer(),
                SizedBox(
                  height: 25,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserFormPage(),
                        ),
                      );

                      // Si el resultado es true, refresca la lista de usuarios
                      if (result == true) {
                        _refreshUsuarios();
                      }
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
              future: _usuariosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay usuarios disponibles'));
                } else {
                  //ordeno las cards
                  List<Map<String, dynamic>> usuariosOrdenados = snapshot.data!
                    ..sort((a, b) {
                      String nombreA = a['nombre'] ?? '';
                      String nombreB = b['nombre'] ?? '';
                      return nombreA.compareTo(nombreB);
                    });

                  return ListView.builder(
                    itemCount: usuariosOrdenados.length,
                    itemBuilder: (context, index) {
                      var user = usuariosOrdenados[index];
                      return UserCard(
                        user: user,
                        onDelete:
                            _refreshUsuarios, // Pasar la referencia al método
                      );
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

//Cards Usuarios
class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final nombre = user['nombre'] ?? 'Nombre Usuario';
    final telefono = user['telefono'] ?? 'Teléfono';
    final direccion = user['direccion'] ?? 'Dirección';
    final correo = user['correo'] ?? 'Correo';
    final cedula = user['id'] ?? 'Cédula'; // El id = nombre doc = cedula

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
                    nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    telefono,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    direccion,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    correo,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            _showEditDialog(
                              context,
                              cedula,
                              nombre,
                              telefono,
                              correo,
                              direccion,
                              onDelete, // Pasa la función aquí
                            );
                          },
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
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Llama al servicio de eliminar usuario
                            await deletePersona(cedula);

                            // Muestra un mensaje de éxito
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Usuario eliminado con éxito')),
                            );

                            // Refresca la lista de usuarios
                            onDelete();
                          },
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

//Alert Dialog Editar Usuario
void _showEditDialog(BuildContext context, String cedula, String nombre,
    String telefono, String correo, String direccion, Function() onUpdate) {
  final _nombreController = TextEditingController(text: nombre);
  final _telefonoController = TextEditingController(text: telefono);
  final _correoController = TextEditingController(text: correo);
  final _direccionController = TextEditingController(text: direccion);

  showDialog(
    barrierColor: Color.fromRGBO(255, 255, 255, 0.85),
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: AppColors.primaryVariantColor,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Editar Usuario',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(labelText: 'Nombre'),
                        ),
                        TextFormField(
                          controller: _telefonoController,
                          decoration: const InputDecoration(labelText: 'Teléfono'),
                        ),
                        TextFormField(
                          controller: _correoController,
                          decoration: const InputDecoration(labelText: 'Correo'),
                        ),
                        TextFormField(
                          controller: _direccionController,
                          decoration: const InputDecoration(labelText: 'Dirección'),
                        ),
                        const SizedBox(height: 10),
                        Text('Cédula: $cedula',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              OverflowBar(
                children: [
                  ElevatedButton(
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryVariantColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      // Actualiza el usuario
                      await updatePersona(
                        cedula,
                        _nombreController.text.trim(),
                        _telefonoController.text.trim(),
                        _correoController.text.trim(),
                        _direccionController.text.trim(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Usuario actualizado con éxito')),
                      );
                      Navigator.of(context).pop();
                      onUpdate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryVariantColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


//Página de añadir usuario
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
        centerTitle: true, // Centra el logo
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
            child: const Text(
              'AGREGAR USUARIO',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 25, 30, 20),
                  child: const _UserForm(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Formulario Añadir Usuario
class _UserForm extends StatefulWidget {
  const _UserForm();

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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cédula',
                          style: Theme.of(context).textTheme.bodyMedium),
                      CustomTextFormField(
                        controller: _cedulaController,
                        formFieldType: FormFieldType.identity_card,
                        hintText: 'Cédula Usuario',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0), // Añade un espacio entre los dos campos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre',
                          style: Theme.of(context).textTheme.bodyMedium),
                      CustomTextFormField(
                        controller: _nombreController,
                        formFieldType: FormFieldType.name,
                        hintText: 'Nombre Usuario',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contraseña',
                          style: Theme.of(context).textTheme.bodyMedium),
                      CustomTextFormField(
                        controller: _claveController,
                        formFieldType: FormFieldType.password,
                        hintText: 'Contraseña',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Teléfono',
                          style: Theme.of(context).textTheme.bodyMedium),
                      CustomTextFormField(
                        controller: _telefonoController,
                        formFieldType: FormFieldType.phone,
                        hintText: 'Teléfono Usuario',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dirección',
                    style: Theme.of(context).textTheme.bodyMedium),
                CustomTextFormField(
                  controller: _direccionController,
                  formFieldType: FormFieldType.address,
                  hintText: 'Dirección Usuario',
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email', style: Theme.of(context).textTheme.bodyMedium),
                CustomTextFormField(
                  controller: _correoController,
                  formFieldType: FormFieldType.email,
                  hintText: 'Email Usuario',
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Valida el formulario
                    String cedula = _cedulaController.text.trim();
                    String nombre = _nombreController.text.trim();
                    String clave = _claveController.text.trim();
                    String telefono = _telefonoController.text.trim();
                    String correo = _correoController.text.trim();
                    String direccion = _direccionController.text.trim();

                    // Validar si el usuario ya existe
                    bool exists = await validateID(cedula);
                    if (exists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'La cédula ingresada pertenece a un usuario existente.')),
                      );
                    } else {
                      // Crea el usuario usando el servicio
                      await addPersona(
                          cedula, nombre, clave, telefono, correo, direccion);

                      // Muestra mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Usuario registrado con éxito')),
                      );

                      // Regresa a la página anterior y pasa un valor booleano
                      Navigator.pop(context, true);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryVariantColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Registrar',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
