import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_bloc/post_data/event.dart';
import 'package:flutter_firebase_bloc/service/post_repository.dart';
import 'package:intl/intl.dart';

import '../post_data/bloc.dart';
import '../post_data/state.dart';

class PostData extends StatefulWidget {
  const PostData({Key? key}) : super(key: key);

  @override
  State<PostData> createState() => _PostDataState();
}

class _PostDataState extends State<PostData> {
  @override
  void initState() {
    BlocProvider.of<PostDataBloc>(context);
    super.initState();
  }

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('user');
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);

    return BlocProvider(
      create: (_) => PostDataBloc(
          postAPI: RepositoryProvider.of<PostApiRepository>(context)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post Data'),
        ),
        body: BlocListener<PostDataBloc, PostDataState>(
          listener: (context, state) {
            if (state is PostLoading) {
              progressIndicator();
            } else if (state is PostLoaded) {
              SingleChildScrollView(
                child: Column(
                  children: [
                    textField('Problem Title', title),
                    textField('Problem Description', description),
                    textField('Problem Location', location),
                    showDate(formattedDate),
                    Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              BlocProvider.of<PostDataBloc>(context).add(
                                  PostEvent(
                                      problemTitle: title.text,
                                      problemDecription: description.text,
                                      problemLocation: location.text,
                                      date: formattedDate));
                            },
                            child: const Text('Submit')))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget textField(
    String text,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: text, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget showDate(String currentDate) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
            hintText: currentDate, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget attachment() {
    FilePickerResult? result;
    String filename = 'No file selected';
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StatefulBuilder(builder: (context, setState) {
        return TextField(
            decoration: InputDecoration(
                hintText: filename,
                suffix: ElevatedButton(
                    onPressed: () async {
                      result = await FilePicker.platform
                          .pickFiles(allowMultiple: true);
                      if (result == null) {
                        print("No file selected");
                      } else {
                        setState(() {
                          result?.files.forEach((element) {
                            filename = element.name;
                            print(filename);
                          });
                        });
                      }
                    },
                    child: const Text('Add Attachment')),
                border: const OutlineInputBorder()));
      }),
    );
  }

  // Widget submitButton(BuildContext context) {
  //   return Center(
  //       child: ElevatedButton(
  //           onPressed: () async {
  //             BlocProvider.of<PostDataBloc>(context).add(PostEvent(problemTitle:title.text,problemDecription: description.text,problemLocation: location.text,date: ))
  //           }, child: const Text('Submit')));
  // }

  Widget progressIndicator() {
    return const CircularProgressIndicator();
  }
}
