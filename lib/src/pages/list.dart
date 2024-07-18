import 'package:bloc_yapisi/src/elements/addButton.dart';
import 'package:bloc_yapisi/src/widgets/list_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc_yapisi/src/blocs/listBLoC/list_bloc.dart';
import 'package:bloc_yapisi/src/blocs/listBLoC/list_event.dart';
import 'package:bloc_yapisi/src/blocs/listBLoC/list_state.dart';
import '../elements/pageLoading.dart';
import '../elements/appBar.dart';
import 'listDetail.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int limit = 5;

  @override
  Widget build(BuildContext context) => BlocProvider<ListBloc>(
      create: (context) => ListBloc()..add(GetListVehicles(limit: limit)),
      child: Scaffold(
          appBar: appBar(title: 'Liste'),
          body: BlocConsumer<ListBloc, ListState>(
              listener: (vehicleContext, vehicleState) {
                if (vehicleState is ListSuccessState) {
                  print(vehicleState.listData.toString());
                } else if (vehicleState is ListErrorState) {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          const AlertDialog(content: Text('HATA')));
                } else if (vehicleState is DeleteSuccess) {
                  vehicleContext
                      .read<ListBloc>()
                      .add(GetListVehicles(limit: limit));
                }
              },
              builder: (vehicleContext, vehicleState) => vehicleState
                      is! ListSuccessState
                  ? pageLoading()
                  : Column(
                      children: [
                        addButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ListDetailScreen()));
                            },
                            title: 'Bas'),
                        listScrollList(
                            vehicleState: vehicleState,
                            limit: limit,
                            onDelete: (index) {
                              vehicleContext.read<ListBloc>().add(DeleteVehicle(
                                  deviceId: vehicleState.listData[index].id));
                            })
                      ],
                    ))));
}
