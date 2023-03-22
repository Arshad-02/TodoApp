import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
    Fluttertoast.showToast(msg: 'Task added');
    titleController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    label: Text('Enter title'), border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 260,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: descriptionController,
                maxLines: null,
                expands: true,
                //keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    //border: OutlineInputBorder(),
                    filled: true,
                    label: Text('Enter a message')),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      addtasktofirebase();
                    },
                    child: const Text('Add task')))
          ],
        ),
      ),
    );
  }
}
