import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_bloc/post_data/bloc.dart';
import 'package:flutter_firebase_bloc/view/post_data.dart';

import '../service/post_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase Storage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buttons(true, context), buttons(false, context)],
        ),
      ),
    );
  }

  Widget buttons(bool isCreate, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                        isCreate ? BlocProvider(
                          create: (context) => PostDataBloc(postAPI: PostApiRepository()),
                          child: RepositoryProvider(
                              create: (_) => PostApiRepository(),
                              child: const PostData()),
                        )
                            : const PostData()));
              },
              child: isCreate
                  ? const Text('Create Data')
                  : const Text('Get Data'))),
    );
  }
}
