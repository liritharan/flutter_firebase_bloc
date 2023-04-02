import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_bloc/service/post_repository.dart';
import 'package:intl/intl.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class PostDataPage extends StatefulWidget {
  PostDataPage({super.key});

  @override
  State<PostDataPage> createState() => _PostDataPageState();
}

class _PostDataPageState extends State<PostDataPage> {
  final PostDataBloc bloc = PostDataBloc(postAPI: PostApiRepository());
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('user');

  final TextEditingController title = TextEditingController();

  final TextEditingController description = TextEditingController();

  final TextEditingController location = TextEditingController();

  @override
  void initState() {
    // bloc.add(const PostEvent());
    super.initState();
  }

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

    return BlocProvider(
      create: (_) => PostDataBloc(
          postAPI: RepositoryProvider.of<PostApiRepository>(context)),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Post Data'),
          ),
          body: BlocProvider(
            create: (context) => bloc,
            child: BlocListener<PostDataBloc, PostDataState>(
              listener: (context, state) {
                if (state is PostError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                  print(state.error);
                }
                else  if (state is PostSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                  print(state.message);
                }
              },
              child: BlocBuilder<PostDataBloc, PostDataState>(
                builder: (context, state) {
                  if(state is PostInitial){
                    return    SingleChildScrollView(
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
                                            problemDescription: description.text,
                                            problemLocation: location.text,
                                            date: formattedDate));
                                  },
                                  child: const Text('Submit')))
                        ],
                      ),
                    );
                  }
                if(state is PostLoading){
                  return _buildLoading();
                }
                else if(state is PostLoaded){
                  return    SingleChildScrollView(
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
                                          problemDescription: description.text,
                                          problemLocation: location.text,
                                          date: formattedDate));
                                },
                                child: const Text('Submit')))
                      ],
                    ),
                  );
                }
                else{
                  return Container();
                }
                },
              ),
            ),
          )),
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
  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
