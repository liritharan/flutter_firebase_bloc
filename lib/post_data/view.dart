import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_bloc/service/post_repository.dart';
import 'package:intl/intl.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class PostDataPage extends StatelessWidget {
  PostDataPage({super.key});

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('user');
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          PostDataBloc(postAPI: PostApiRepository()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    final bloc = BlocProvider.of<PostDataBloc>(context);

    return BlocProvider(
      create: (_) => PostDataBloc(
          postAPI: RepositoryProvider.of<PostApiRepository>(context)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post Data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              textField('Problem Title', title),
              textField('Problem Description', description),
              textField('Problem Location', location),
              showDate(formattedDate),
              Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        BlocProvider.of<PostDataBloc>(context).add(PostEvent(
                            problemTitle: title.text,
                            problemDecription: description.text,
                            problemLocation: location.text,
                            date: formattedDate));
                      },
                      child: const Text('Submit')))
            ],
          ),
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
