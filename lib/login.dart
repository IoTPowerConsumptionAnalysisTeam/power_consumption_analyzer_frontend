import 'package:flutter/material.dart';
import 'package:power_consumption_analyzer_frontend/user_request_handler.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
                onChanged: (value) {
                  username = value;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  debugPrint('login...');
                  await UserRequestHandler.I.register(username: username);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Welcome $username'),
                    ),
                  );
                } catch (e) {
                  debugPrint('failed login...');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to register'),
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
