import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/screens/loginpage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool seePassword = false;
  bool seeConfirmpassword = false;

  FocusNode userNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmpasswordFocus = FocusNode();

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "HELLO THERE",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: userNameFocus,
                        validator: (value) {
                          if (usernameController.text.length < 4) {
                            return "Username length must be atleast 4";
                          }
                          return null;
                        },
                        controller: usernameController,
                        decoration: const InputDecoration(
                          hintText: "username (min 4 characters)",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        focusNode: passwordFocus,
                        validator: (value) {
                          if (passwordController.text.length < 8) {
                            return "Password length must be atleast 8";
                          }
                          return null;
                        },
                        controller: passwordController,
                        obscureText: !seePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                seePassword = !seePassword;
                              });
                            },
                            icon: seePassword
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          hintText: "password (min 8 characters)",
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        focusNode: confirmpasswordFocus,
                        validator: (value) {
                          if (passwordController.text !=
                              confirmpasswordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        controller: confirmpasswordController,
                        obscureText: !seeConfirmpassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                seeConfirmpassword = !seeConfirmpassword;
                              });
                            },
                            icon: seeConfirmpassword
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          hintText: "confirm password",
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // go to login page
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.grey.shade300),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.black),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      userNameFocus.unfocus();
                      passwordFocus.unfocus();
                      confirmpasswordFocus.unfocus();

                      await dbHelper.insertUser(
                        User(
                          username: usernameController.text,
                          password: passwordController.text,
                        ),
                      );
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text("REGISTER"),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account ? ",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login here",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
