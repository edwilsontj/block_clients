import 'dart:math';

import 'package:block_clients/clientes/blocs/client_blocs.dart';
import 'package:block_clients/clientes/blocs/client_events.dart';
import 'package:block_clients/clientes/blocs/client_state.dart';
import 'package:block_clients/clientes/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  // final clientsList = [];
  late final ClientBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = ClientBloc();
    bloc.add(LoadClientEvent());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.close();
  }

  String randomName() {
    final rand = Random();
    return ['Maria Almeida', 'Vinicius Silva', 'Luiz Williams', 'Bianca Nevis']
        .elementAt(rand.nextInt(4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                bloc.add(AddClientEvent(client: Client(nome: randomName())));
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: BlocBuilder<ClientBloc, ClientState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is ClientInitialState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ClientSuccessState) {
              final clientsList = state.clients;
              return ListView.separated(
                itemCount: clientsList.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    child: ClipRRect(
                      child: Text(clientsList[index].nome.substring(0, 1)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  title: Text(clientsList[index].nome),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      bloc.add(RemoveClientEvent(client: clientsList[index]));
                    },
                  ),
                ),
                separatorBuilder: (_, __) => const Divider(),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
