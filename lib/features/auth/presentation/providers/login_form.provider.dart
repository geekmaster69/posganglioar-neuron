import 'package:candy_tracker/features/auth/presentation/providers/providers.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';

import '../../../shared/shared.dart';

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
      final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

      return LoginFormNotifier(loginUserCallback);
    });

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(Map<String, dynamic>) loginUserCallback;

  LoginFormNotifier(this.loginUserCallback) : super(LoginFormState());

  void onEmailChange(String value) {
    final newEmail = Email.dirty(value.trim());
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  void onPasswordChange(String value) {
    final newPassword = Password.dirty(value.trim());
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.email, newPassword]),
    );
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await loginUserCallback({
      'email': state.email.value,
      'password': state.password.value,
    });

    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }

  void toggleObscureText() {
    final obscureText = state.showPassword;

    state = state.copyWith(showPassword: !obscureText);
  }
}

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool showPassword;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.showPassword = true,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? showPassword,
    Email? email,
    Password? password,
  }) {
    return LoginFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      showPassword: showPassword ?? this.showPassword,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
