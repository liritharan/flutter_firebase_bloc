import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_bloc/model/postModel.dart';
import 'package:flutter_firebase_bloc/service/get_repository.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class CovidPage extends StatefulWidget {
  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  final RetriveDataBloc _newsBloc = RetriveDataBloc( getApi: GetApiRepository());

  @override
  void initState() {
    _newsBloc.add(GetDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Data')),
      body: _buildWidget(),
    );
  }

  Widget _buildWidget() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocListener<RetriveDataBloc, RetriveDataState>(
          listener: (context, state) {
            if (state is GetDataErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
              print(state.error);
            }

          },
          child: BlocBuilder<RetriveDataBloc, RetriveDataState>(
            builder: (context, state) {
              if (state is GetDataLoadingState) {
                return _buildLoading();
              } else if (state is GetDataLoadedState) {

                return _buildCard(context,state.data);
              } else if (state is GetDataErrorState) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, dynamic data) {
    List<FirebaseModel> getData = data;
    return ListView.builder(
      itemCount: getData.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Problem Title: ${getData[index].problemTitle}"),
                  Text("Problem Description: ${getData[index].problemDescription}"),
                  Text("Problem Location: ${getData[index].problemLocation}"),
                  Text("Problem Date: ${getData[index].date}"),
                   ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
