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
      appBar: AppBar(title: Text('COVID-19 List')),
      body: _buildListCovid(),
    );
  }

  Widget _buildListCovid() {
    return Container(
      margin: EdgeInsets.all(8.0),
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
                List<FirebaseModel> data = state.data;
                return Text(data.length.toString());
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

  Widget _buildCard(BuildContext context, FirebaseModel model) {
    return ListView.builder(
      itemCount: model.problemTitle!.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text("Country: ${model.problemTitle}"),
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
