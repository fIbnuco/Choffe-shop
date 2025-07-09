import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../model/model_database.dart';

class FragmentHistory extends StatefulWidget {
  const FragmentHistory({super.key});

  @override
  State<FragmentHistory> createState() => _FragmentHistoryState();
}

class _FragmentHistoryState extends State<FragmentHistory> {
  late DatabaseHelper dbHelper;
  late Future<List<ModelDatabase>> mdlDatabase;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _refreshStudentList();
  }

  void _refreshStudentList() {
    setState(() {
      mdlDatabase = dbHelper.readAllStudents();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<List<ModelDatabase>>(
        future: mdlDatabase,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Ups, history empty!'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final student = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  AlertDialog alertDialog = AlertDialog(
                    title: const Text('Delete Data?',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black)
                    ),
                    content: const SizedBox(
                      height: 20,
                      child: Column(
                        children: [
                          Text('Are you sure you want to delete this data??',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black)
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            await dbHelper.delete(student.id!);
                            _refreshStudentList();
                            Navigator.pop(context);
                          },
                          child: const Text('Yes',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black)
                          )
                      ),
                      TextButton(
                        child: const Text('Cancel',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black)
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                  showDialog(
                      context: context,
                      builder: (context) => alertDialog);
                },
                child: Card(
                    margin: const EdgeInsets.all(10),
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student.tgl_order.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(
                              height: 20
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      student.nama.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16
                                      ), maxLines: 2,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      student.ket.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                width: 80,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(20),
                                    child: Image.network(student.image_url.toString(),
                                        fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                              height: 20
                          ),
                          Text('Size ${student.size} - ${student.jml_uang}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10
                            ),
                          )
                        ],
                      ),
                    )
                ),
              );
            },
          );
        },
      ),
    );
  }
}
