import 'package:candy_tracker/config/config.dart';
import 'package:candy_tracker/features/auth/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:candy_tracker/features/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginFormState = ref.watch(loginFormProvider);
    final loginFormNotifier = ref.read(loginFormProvider.notifier);

    Future<void> _login() async {
      await loginFormNotifier.onFormSubmit();
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
              'Ahora estas asustado?',
              style: textStyle.titleLarge?.copyWith(color: Colors.white),
            ),
            Text(
              'Inicia secion para continuar',
              style: textStyle.titleLarge?.copyWith(color: Colors.white),
            ),
            CustomTextFormField(
              label: 'email',
              keyboardType: TextInputType.emailAddress,
              onChanged: loginFormNotifier.onEmailChange,
              errorMessage: loginFormState.isFormPosted
                  ? loginFormState.email.errorMessage
                  : null,
            ),
            CustomTextFormField(
              label: 'password',
              keyboardType: TextInputType.visiblePassword,
              onChanged: loginFormNotifier.onPasswordChange,
              onFieldSubmitted: (value) async {
                await _login();
                
              },
              errorMessage: loginFormState.isFormPosted
                  ? loginFormState.password.errorMessage
                  : null,
            ),

            SizedBox(
              height: 64,
              width: double.maxFinite,
              child: FilledButton.icon(
                onPressed: () async {
                  await _login();
                },
                icon: (loginFormState.isPosting)
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
