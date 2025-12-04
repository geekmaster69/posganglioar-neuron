import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastrucure.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(AuthDatasourceImpl());
});
