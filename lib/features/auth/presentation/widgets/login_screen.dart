import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:test_invitech/constants/app_colors.dart';
import 'package:test_invitech/constants/app_sizes.dart';
import 'package:test_invitech/features/auth/presentation/controllers/auth_controller.dart';
import 'package:test_invitech/routing/app_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future login() async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(fontSize: Sizes.p20, color: ColorApp.black),
            ),
            gapH12,
            SizedBox(
              height: Sizes.p64,
              child: state.value.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : OutlinedButton.icon(
                      onPressed: () async {
                        final result = await ref
                            .read(authControllerProvider.notifier)
                            .onLogin();
                        if (result) {
                          context.replaceNamed(AppRoute.album.name);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: ColorApp.error,
                                  content: Text(
                                    'Login fail!',
                                    style: TextStyle(color: ColorApp.white),
                                  )));
                        }
                      },
                      icon: const Icon(FontAwesome.google),
                      label: const Text(
                        'Login with Google account',
                        style: TextStyle(fontSize: Sizes.p16),
                      ),
                    ),
            )
          ],
        )),
      ),
    );
  }
}
