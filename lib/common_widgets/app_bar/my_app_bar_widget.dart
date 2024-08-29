import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:test_invitech/constants/app_colors.dart';
import 'package:test_invitech/constants/app_sizes.dart';
import 'package:test_invitech/features/auth/data/auth_repository.dart';
import 'package:test_invitech/features/auth/presentation/controllers/auth_controller.dart';
import 'package:test_invitech/routing/app_router.dart';

class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authRepositoryProvider).getUser();
    return auth == null
        ? AppBar()
        : AppBar(
            backgroundColor: ColorApp.primary,
            foregroundColor: ColorApp.white,
            // leadingWidth: double.infinity,
            toolbarHeight: 70,
            leading: Padding(
              padding: EdgeInsets.only(left: Sizes.p8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(auth.photoUrl!),
              ),
            ),
            centerTitle: true,
            title: Text(
              auth.displayName!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Are you sure logout?",
                              style: TextStyle(color: ColorApp.error),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Cancle')),
                              TextButton(
                                  onPressed: () async {
                                    final result = await ref
                                        .read(authControllerProvider.notifier)
                                        .onLogout();
                                    if (result) {
                                      context.replaceNamed(AppRoute.login.name);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Logout fail!')));
                                    }
                                  },
                                  child: const Text('Yes'))
                            ],
                          );
                        });
                  },
                  icon: const Icon(FontAwesome.logout))
            ],
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
