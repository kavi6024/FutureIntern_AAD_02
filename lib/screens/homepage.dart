import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/screens/loginpage.dart';
import 'package:todo_app/screens/taskpage.dart';
import 'package:todo_app/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String? user = SharedPrefs().getString("user");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          color: const Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 32.0,
                          bottom: 32.0,
                        ),
                        child: const Image(
                          image: AssetImage('assets/images/logo.png'),
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 32.0,
                          bottom: 32.0,
                        ),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title:
                                      Text("Are you sure you want to logout, $user ?"),
                                  children: [
                                    SimpleDialogOption(
                                      onPressed: () async {
                                        await SharedPrefs().remove("user");
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const LoginPage(),
                                          ),
                                        );
                                      },
                                      child: const Text("Yes"),
                                    ),
                                    SimpleDialogOption(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.exit_to_app_rounded,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: const [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        int? len = snapshot.data?.length;
                        if (len! > 0) {
                          return ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: ListView.builder(
                              itemCount: len,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Taskpage(
                                          task: snapshot.data?[index],
                                        ),
                                      ),
                                    ).then(
                                      (value) {
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: TaskCardWidget(
                                    title: snapshot.data?[index].title ?? "",
                                    desc:
                                        snapshot.data?[index].description ?? "",
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              "No tasks, $user ? Create one 👇",
                              style: const TextStyle(fontSize: 17.5),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Taskpage(
                                task: null,
                              )),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0)),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Image(
                      image: AssetImage(
                        "assets/images/add_icon.png",
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
