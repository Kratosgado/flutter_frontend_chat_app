import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/models/models.dart';
import 'package:flutter_frontend_chat_app/data/network/services/socket.service.dart';
import 'package:flutter_frontend_chat_app/data/network/services/user.controller.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/resources/utils.dart';
import 'package:flutter_frontend_chat_app/views/utils/select_image.dart';
import 'package:flutter_frontend_chat_app/views/utils/view_picture.dart';
import 'package:get/get.dart';

import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final enabled = false.obs;
    final email = SocketService.currentAccount.user.email.obs;
    final username = SocketService.currentAccount.user.username.obs;
    final currentUser = SocketService.currentAccount.user;
    Rx<String?> selectedImage = currentUser.profilePic.obs;

    TextField field(String type, TextEditingController controller) {
      return TextField(
        enabled: enabled.value,
        controller: controller,
        onSubmitted: (value) => type == "email"
            ? email.value = value
            : type == "username"
                ? username.value = value
                : null,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          label: Text(type),
          labelStyle: Theme.of(context).textTheme.titleLarge,
          prefixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => enabled.value = !enabled.value,
          ),
        ],
        // backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: Get.height,
        padding: const EdgeInsets.all(Spacing.s4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Spacing.s12),
          gradient: LinearGradient(
            colors: [ColorManager.topColor, ColorManager.bottomColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                GestureDetector(
                  onTap: () => viewProfileImage(currentUser),
                  child: Container(
                    height: Spacing.s190,
                    // padding: const EdgeInsets.all(Spacing.s5),
                    margin: const EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: StyleManager.boxDecoration.copyWith(
                      shape: BoxShape.circle,
                      borderRadius: null,
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black,
                          blurRadius: Spacing.s4,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: Hero(
                      tag: 'profile_pic${currentUser.id}',
                      child: CircleAvatar(
                        radius: Spacing.s90 + 2,
                        backgroundImage: MemoryImage(
                          selectedImage.value != null
                              ? TypeDecoder.toBytes(selectedImage.value!)
                              : TypeDecoder.defaultPic,
                          // filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ),
                  ),
                ),
                enabled.value
                    ? TextButton(
                        style: ButtonStyle(
                            foregroundColor:
                                WidgetStateColor.resolveWith((states) => Colors.blue.shade100)),
                        onPressed: () async {
                          File? pickedFile = await selectImage();
                          if (pickedFile != null) {
                            selectedImage.value = TypeDecoder.imageToBase64(pickedFile);
                          }
                        },
                        child: const Text("Change Profile Pic"),
                      )
                    : const SizedBox(
                        height: Spacing.s8,
                      ),
                field("username", TextEditingController(text: username.value)),
                const SizedBox(
                  height: Spacing.s8,
                ),
                field("email", TextEditingController(text: email.value)),
                if (enabled.value)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: ShaderMask(
                        shaderCallback: ((bounds) => const LinearGradient(colors: [
                              Colors.white,
                              Colors.blue,
                            ]).createShader(bounds)),
                        child: const Text("save")),
                    onPressed: () async {
                      final user = User(
                        id: currentUser.id,
                        email: email.value,
                        username: username.value,
                        profilePic: selectedImage.value,
                      );

                      await UserController().updateUser(user);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
