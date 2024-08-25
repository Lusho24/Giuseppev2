import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Obtener lista de usuarios
Future<List<Map<String, dynamic>>> getPersonas() async {
  List<Map<String, dynamic>> usuarios = [];

  try {
    CollectionReference collectionReference = db.collection('usuario');
    QuerySnapshot queryPersonas = await collectionReference.get();

    for (var documento in queryPersonas.docs) {
      Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
      data['id'] = documento.id;
      usuarios.add(data);
    }
  } catch (e) {
    print("Error obteniendo lista de usuarios: $e");
  }

  return usuarios;
}

// Agregar un nuevo usuario
Future<void> addPersona(String cedula, String nombre, String clave, String telefono, String correo, String direccion) async {
  try {
    // Validar existencia de documento con ese ID de cedula
    DocumentSnapshot existingUser = await db.collection('usuario').doc(cedula).get();
    if (existingUser.exists) {
      print("El usuario con esta cédula ya existe.");
      return;
    }

    // Crear nuevo documento con la cédula como ID
    await db.collection('usuario').doc(cedula).set({
      'nombre': nombre,
      'clave': clave,
      'telefono': telefono,
      'correo': correo,
      'direccion': direccion,
    });
  } catch (e) {
    print("Error agregando usuario: $e");
  }
}

// Actualizar un usuario existente
Future<void> updatePersona(String cedula, String nombre, String telefono, String correo, String direccion, String clave) async {
  try {
    // Validar usuario antes de actualizar
    bool isValidUser = await validateUsuario(cedula, clave);
    if (isValidUser) {
      await db.collection('usuario').doc(cedula).update({
        'nombre': nombre,
        'telefono': telefono,
        'correo': correo,
        'direccion': direccion,
      });
    } else {
      print("No se puede actualizar. Usuario o clave inválida.");
    }
  } catch (e) {
    print("Error actualizando usuario: $e");
  }
}

// Eliminar un usuario
Future<void> deletePersona(String cedula, String clave) async {
  try {
    // Validar usuario antes de eliminar
    bool isValidUser = await validateUsuario(cedula, clave);
    if (isValidUser) {
      await db.collection('usuario').doc(cedula).delete();
    } else {
      print("No se puede eliminar. Usuario o clave inválida.");
    }
  } catch (e) {
    print("Error eliminando usuario: $e");
  }
}

// Validar el usuario y la contraseña
Future<bool> validateUsuario(String cedula, String clave) async {
  try {
    // Obtener el documento con la cedula ingresada
    DocumentSnapshot documento = await db.collection('usuario').doc(cedula).get();

    if (documento.exists) {
      Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

      if (data['clave'] == clave) {
        return true; // Clave correcta
      } else {
        print("La clave no coincide."); // Clave incorrecta
        return false;
      }
    } else {
      print("El usuario no existe."); // si no encontre el doc
      return false;
    }
  } catch (e) {
    print("Error validando usuario: $e"); // Error si no cumplio nada
    return false;
  }
}
