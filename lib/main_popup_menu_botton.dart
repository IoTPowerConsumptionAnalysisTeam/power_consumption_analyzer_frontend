import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/login.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category_manager.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_manager.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_request_handler.dart';
import 'package:power_consumption_analyzer_frontend/request_handler.dart';
import 'package:power_consumption_analyzer_frontend/user_request_handler.dart';

class MainPopupMenuButton extends StatefulWidget {
  const MainPopupMenuButton({super.key});

  @override
  _MainPopupMenuButtonState createState() => _MainPopupMenuButtonState();
}

class _MainPopupMenuButtonState extends State<MainPopupMenuButton> {
  final TextEditingController _serverUrlController = TextEditingController(
    text: RequestHandler.I.baseUrl,
  );
  final TextEditingController _powerSocketNameController =
      TextEditingController();
  final TextEditingController _powerSocketCategoryNameController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          'login',
          'set server url',
          'add power socket category',
          'add power socket',
          'delete all power socket',
        ].map((e) {
          return PopupMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList();
      },
      onSelected: (value) {
        switch (value) {
          case 'login':
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            );
            break;
          case 'set server url':
            showDialog(
              context: context,
              builder: (context) {
                _serverUrlController.text = RequestHandler.I.baseUrl;
                return AlertDialog(
                  title: const Text('Set Server URL'),
                  content: TextField(
                    controller: _serverUrlController,
                    decoration: const InputDecoration(hintText: 'Server URL'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        RequestHandler.I.baseUrl = _serverUrlController.text;
                        Navigator.of(context).pop();
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                );
              },
            );
            break;
          case 'add power socket category':
            break;
          case 'add power socket':
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Power Socket'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _powerSocketNameController,
                        decoration: const InputDecoration(
                            hintText: 'Power Socket Name'),
                      ),
                      TextField(
                        controller: _powerSocketCategoryNameController,
                        decoration: const InputDecoration(
                            hintText: 'Power Socket Category Name'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (UserRequestHandler.I.userId == null) {
                          return;
                        }
                        String userId = UserRequestHandler.I.userId;
                        String name = _powerSocketNameController.text;
                        String categoryName =
                            _powerSocketCategoryNameController.text;
                        PowerSocketRequestHandler.I.registerPowerSocket(
                          userId: userId,
                          powerSocketName: name,
                          powerSocketCategoryName: categoryName,
                        );
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              },
            );
            break;
          case 'delete all power socket':
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete All Power Socket'),
                  content: const Text('Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (UserRequestHandler.I.userId == null) {
                          return;
                        }
                        String userId = UserRequestHandler.I.userId;
                        PowerSocketRequestHandler.I
                            .deleteAllPowerSocket(userId: userId);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
        }
      },
    );
  }
}
