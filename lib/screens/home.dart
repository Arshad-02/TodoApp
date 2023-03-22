import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/screens/add_task.dart';
import 'package:todo/screens/description.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '1';
  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User = await auth.currentUser!;
    setState(() {
      uid = User.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo App"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('mytasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  DateTime time =
                      (docs[index]['timestamp'] as Timestamp).toDate();
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Description(
                                    title: docs[index]['title'],
                                    description: docs[index]['description'],
                                  )));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 15,
                                ), //top: 10),
                                child: Text(docs[index]['title'],
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.deepOrange,
                                        overflow: TextOverflow.fade)),
                              ),

                              /* preview of desc 
                                Container(
                                margin: const EdgeInsets.only(
                                  left: 15,
                                ),
                                child: Text(
                                  docs[index]['description'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),*/
                              const SizedBox(height: 5),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 15,
                                ),
                                child: Text(
                                    DateFormat.yMd().add_jm().format(time)),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.grey,
                                onPressed: () {
                                  //edit the document
                                  debugPrint('Edit feature to be added');
                                },
                              )),
                              Container(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(uid)
                                        .collection('mytasks')
                                        .doc(docs[index]['time'])
                                        .delete();
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.deepOrange),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTask()));
        },
      ),
    );
  }
}
