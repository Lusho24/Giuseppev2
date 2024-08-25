import 'package:flutter/material.dart';
import 'package:giuseppe/features/presentation/common_widgets/custom_text_form_field.dart';
import 'package:giuseppe/utils/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../services/firebase_services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.only(
                        top: 110.0,
                        bottom: 30.0,),
                child: const Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 130.0,
                ),
              ),
              const Padding(padding: EdgeInsets.all(40.0), child: _SignInForm())
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  const _SignInForm({super.key});

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                Text('Usuario', style: Theme.of(context).textTheme.bodyMedium),
                CustomTextFormField(
                  controller: _idController,
                  formFieldType: FormFieldType.identity_card,
                  hintText: '1705380561',
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
                  controller: _passwordController,
                  formFieldType: FormFieldType.password,
                  hintText: '********',
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String id = _idController.text.trim();
                  String clave = _passwordController.text.trim();

                  if (await validateUsuario(id, clave)) {
                    Navigator.pushNamed(context, 'tabs_page');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Credenciales incorrectas')),
                    );
                  }
                },
                child: const Text('Ingresar'),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Recuperar contraseña',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.secondaryColor,
                    decorationThickness: 2.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
