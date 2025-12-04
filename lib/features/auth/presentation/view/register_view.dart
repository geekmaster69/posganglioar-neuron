import 'package:candy_tracker/config/helpers/scaffold_message.dart';
import 'package:flutter/material.dart';

import 'package:candy_tracker/features/auth/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:candy_tracker/features/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerFormState = ref.watch(registerFormProvider);
    final registerFormNotifier = ref.read(registerFormProvider.notifier);

    Future<void> _register() async {
      await registerFormNotifier.onFormSubmit();
      final autState = ref.read(authProvider).authStatus;
      if (autState == AuthStatus.authenticated) {
        context.pushReplacement('/');
      }
    }

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        showSnackBar(context, next.errorMessage);
      }
    });

    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 20),
            Text(
              'RASTREADOR DE DULCES',
              style: textStyle.headlineMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),

            Text(
              'Aterradoramente gratis!!!',
              style: textStyle.titleLarge?.copyWith(color: Colors.white),
            ),
            Text(
              'Crea una cuenta para continuar',
              style: textStyle.titleLarge?.copyWith(color: Colors.white),
            ),
            CustomTextFormField(
              label: 'usuario',
              keyboardType: TextInputType.name,
              onChanged: registerFormNotifier.onNameChange,
              errorMessage: registerFormState.isFormPosted
                  ? registerFormState.name.errorMessage
                  : null,
            ),
            CustomTextFormField(
              label: 'email',
              keyboardType: TextInputType.emailAddress,
              onChanged: registerFormNotifier.onEmailChange,
              errorMessage: registerFormState.isFormPosted
                  ? registerFormState.email.errorMessage
                  : null,
            ),
            CustomTextFormField(
              label: 'password',
              keyboardType: TextInputType.visiblePassword,
              onChanged: registerFormNotifier.onPasswordChange,
              onFieldSubmitted: (value) async {
                await _register();
              },
              errorMessage: registerFormState.isFormPosted
                  ? registerFormState.password.errorMessage
                  : null,
            ),

            SizedBox(
              height: 64,
              width: double.maxFinite,
              child: FilledButton.icon(
                onPressed: () async {
                  await _register();
                },
                icon: (registerFormState.isPosting)
                    ? const CircularProgressIndicator(color: Colors.green)
                    : const Icon(Icons.login),
                label: const Text('Login', style: TextStyle(fontSize: 22)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
