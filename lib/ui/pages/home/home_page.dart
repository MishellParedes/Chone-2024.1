import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/button_num_ced_search_home.dart';
import 'package:sapo_benefica/ui/pages/home/screens/first_step_home.dart';
import 'package:sapo_benefica/ui/pages/home/screens/second_step_home.dart';
import 'package:sapo_benefica/ui/pages/home/screens/third_step_home.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:sapo_benefica/globals/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    if (globals.isSapo) {
      _channel!.sink.close();
    }
    super.dispose();
  }

  var _oldDniLooked = "";
  final _channel = globals.isSapo
      ? WebSocketChannel.connect(Uri.parse('ws://localhost:8080/ws'))
      : null;
  @override
  Widget build(BuildContext context) {
    final providerHome = Provider.of<ProviderHome>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                globals.isSapo
                    ? StreamBuilder(
                        stream: _channel!.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasError) {
                            // print("Error: ${snapshot.error}");
                            // return Text('');
                          }
                          if (snapshot.hasData) {
                            // print("snapshot data");
                            // print(snapshot.data);
                            if (snapshot.data != "Hola Flutter" &&
                                _oldDniLooked != snapshot.data) {
                              providerHome.formSearchNumCed
                                  .control('num_ced')
                                  .value = snapshot.data;
                              providerHome.formSearchNumCed.control('num_ced');
                              _oldDniLooked = snapshot.data;
                              appWindow.minimize();
                              appWindow.maximizeOrRestore();
                              Future.delayed(Duration.zero, () {
                                providerHome.validateNumCed();
                              });
                            }
                            // if (snapshot.data != "Hola Flutter" &&
                            //     snapshot.data !=
                            //         providerHome.formSearchNumCed
                            //             .control('num_ced')
                            //             .value) {
                            //   providerHome.formSearchNumCed
                            //       .control('num_ced')
                            //       .value = snapshot.data;
                            //   providerHome.formSearchNumCed.control('num_ced');
                            //   appWindow.minimize();
                            //   appWindow.maximizeOrRestore();
                            //   Future.delayed(Duration.zero, () {
                            //     providerHome.validateNumCed();
                            //   });
                            // }
                          }
                          return const SizedBox();
                        })
                    : const SizedBox(),
                SizedBox(
                  height: 730,
                  width: 1050,
                  child: Card(
                    elevation: 3,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(
                        color: ThemeApp.secondary,
                        width: 3,
                      ),
                    ),
                    child: providerHome.cedLength10
                        ? Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              providerHome.screen == 1
                                  ? const FirstStepHome()
                                  : providerHome.screen == 2
                                      ? const SecondStepHome()
                                      : providerHome.screen == 3
                                          ? const ThirdStepHome()
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator()),
                              const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("v3.23.1-benefica"))
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "Buscar Amigo/Cliente",
                                  style: ThemeApp.secondary23_900,
                                ),
                                SizedBox(height: 20),
                                InputNumCedSearchHome(),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
