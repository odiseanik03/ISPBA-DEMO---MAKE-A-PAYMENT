import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionState {
  final bool authenticated;
  final String role;

  const SessionState({required this.authenticated, required this.role});

  SessionState copyWith({bool? authenticated, String? role}) {
    return SessionState(
      authenticated: authenticated ?? this.authenticated,
      role: role ?? this.role,
    );
  }
}

final sessionProvider = StateProvider<SessionState>(
  (ref) => const SessionState(authenticated: false, role: 'CUSTOMER'),
);
