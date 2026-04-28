import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import '../supabase/supabase_client.dart';

/// Raw SupabaseClient — use this to access the client in other providers.
final supabaseClientProvider = Provider<SupabaseClient>((_) => supabase);

/// Stream of auth state changes from Supabase.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

/// The currently signed-in user, or null if not authenticated.
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.session?.user;
});

/// The current user's profile from the users table, or null if not authenticated.
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final response = await supabase
      .from('users')
      .select()
      .eq('id', user.id)
      .maybeSingle();

  if (response == null) return null;
  return UserProfile.fromJson(response);
});

/// Notifier that exposes auth actions (sign in, sign up, sign out, etc.).
class AuthNotifier extends Notifier<void> {
  @override
  void build() {
    // Enforce role check for OAuth sign-ins (email sign-in handles it inline).
    ref.listen(authStateProvider, (_, next) async {
      final state = next.valueOrNull;
      if (state?.event != AuthChangeEvent.signedIn) return;
      final provider =
          state?.session?.user.appMetadata['provider'] as String?;
      if (provider == 'email') return; // handled inline in signInWithEmail

      final user = state?.session?.user;
      if (user == null) return;

      final profile = await supabase
          .from('users')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (profile?['role'] == rolePortOperator) {
        await supabase.auth.signOut();
      }
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final profile = await supabase
        .from('users')
        .select('role')
        .eq('id', response.user!.id)
        .maybeSingle();

    if (profile?['role'] == rolePortOperator) {
      await supabase.auth.signOut();
      throw const AuthException(
        'This account is a port manager account. Please use the web dashboard.',
        statusCode: 'ROLE_MISMATCH',
      );
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'sadamaagent://auth-callback',
      data: {
        'full_name': fullName,
        'role': roleVesselOperator,
      },
    );
  }

  Future<void> signInWithGoogle() async {
    await supabase.auth.signInWithOAuth(OAuthProvider.google);
    // Role check for OAuth is handled by the auth state listener in build().
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }
}

final authProvider = NotifierProvider<AuthNotifier, void>(AuthNotifier.new);
