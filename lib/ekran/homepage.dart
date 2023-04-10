// ignore_for_file: avoid_print, non_constant_identifier_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mobil1/db/post.dart';

import '../db/product.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late Isar isar;
  List<Post> posts = [];

  TextEditingController modelController = TextEditingController();
  TextEditingController renkController = TextEditingController();
  TextEditingController numaraController = TextEditingController();

  late String model;
  late String renk;
  late int numara;

  bool edit = false;
  late int editId;

  addPost(
    String model,
    String renk,
    String resim,
    int numara,
  ) async {
    Post newPost = Post()
      ..model = model
      ..renk = renk
      ..resim = resim
      ..numara = numara;

    await isar.writeTxn(() async {
      var addedID = await isar.posts.put(newPost);
      print(addedID);
    });
  }

  editPost(
    int id,
    String model,
    String renk,
    String resim,
    int numara,
  ) async {
    Post newPost = Post()
      ..id = id
      ..model = model
      ..renk = renk
      ..resim = resim
      ..numara = numara;

    await isar.writeTxn(() async {
      var addedid = await isar.posts.put(newPost);
      getAllNews();
    });
  }

  DeletePost(int id) async {
    isar.writeTxn(() async {
      var result = await isar.posts.delete(id);
      if (result) {
        print('silindi');
        getAllNews();
      } else {
        print('silme hatalı.');
      }
    });
  }

  openConection() async {
    try {
      isar = await Isar.open(
        [PostSchema, ProductSchema],
      );
      if (isar.isOpen) {
        print("we are connectd to database");
        getAllNews();
      } else {
        print("connection faild");
      }
    } catch (e) {
      print("Openconnetcion Error: ");
      print(e);
    }
  }

  getAllNews() async {
    posts = await isar.posts.where().findAll();
    setState(() {});
  }

  closeConection() async {
    try {
      var result = await isar.close();
      if (result) {
        print("connection closed successfulyy");
      } else {
        print("connection not closed.");
      }
    } catch (e) {
      print("CloseError:");
      print(e);
    }
  }

  @override
  void initState() {
    openConection();

    super.initState();
  }

  @override
  void dispose() {
    closeConection();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                model = value;
              });
            },
            controller: modelController,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                renk = value;
              });
            },
            controller: renkController,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                numara = int.parse(value);
              });
            },
            controller: numaraController,
          ),
          ElevatedButton(
            onPressed: () {
              addPost(model, renk, 'assets/shoe.webp', numara);

              getAllNews();
            },
            child: Text('Ekle'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: posts
                    .map(
                      (e) => Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          child: Column(
                            children: [
                              Text("${e.id} ${e.model!}"),
                              Text(e.renk!),
                              Image.asset("${e.resim}"),
                              Text('${e.numara}'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        DeletePost(e.id);
                                      },
                                      child: Icon(Icons.delete)),
                                  ElevatedButton(
                                      onPressed: () {
                                        modelController = TextEditingController(
                                            text: e.model);
                                        renkController =
                                            TextEditingController(text: e.renk);
                                        numaraController =
                                            TextEditingController(
                                                text: e.numara.toString());

                                        edit = true;
                                        setState(() {});
                                      },
                                      child: Icon(Icons.edit)),
                                  edit
                                      ? ElevatedButton(
                                          onPressed: () {
                                            editPost(e.id, model, renk,
                                                "assets/shoe.webp", numara);
                                          },
                                          child: Text("Edit"))
                                      : SizedBox(),
                                ],
                              )
                            ],
                          )),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
