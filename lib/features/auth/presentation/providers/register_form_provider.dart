import 'package:candy_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../shared/shared.dart';

final registerFormProvider =
    NotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
      RegisterFormNotifier.new,
    );

class RegisterFormNotifier extends Notifier<RegisterFormState> {
  @override
  build() {
    return RegisterFormState();
  }

  void onEmailChange(String value) {
    final newEmail = Email.dirty(value.trim());
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  void onNameChange(String value){

    final name = StringInput.dirty(value);
    state = state.copyWith(name: name, isValid: Formz.validate([name]));
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

    // await loginUserCallback({
    //   'email': state.email.value,
    //   'password': state.password.value,
    // });
    await ref.watch(authProvider.notifier).registerUser({
      'email': state.email.value,
      'password': state.password.value,
      'fullName': state.name.value,
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

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool showPassword;
  final Email email;
  final StringInput name;
  final Password password;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.showPassword = true,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const StringInput.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? showPassword,
    Email? email,
    Password? password,
    StringInput? name,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      showPassword: showPassword ?? this.showPassword,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
    );
  }
}
