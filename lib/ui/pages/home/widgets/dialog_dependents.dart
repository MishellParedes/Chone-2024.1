import 'package:flutter/material.dart';
import 'package:sapo_benefica/data/aws/flat_input_text_field.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class DialogDependents extends StatelessWidget {
  const DialogDependents({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    return AlertDialog(
      title: const Text('Beneficiarios', style: ThemeApp.primary20Bold),
      content: SizedBox(
        height: 230,
        width: 800,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 350,
                  child: Text(
                    "Nombres y Apellidos",
                    style: ThemeApp.secondary20_700,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 20),
                const SizedBox(
                  width: 175,
                  child: Text(
                    "Parentesco",
                    style: ThemeApp.secondary20_700,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 20),
                const SizedBox(
                  width: 100,
                  child: Text(
                    "%",
                    style: ThemeApp.secondary20_700,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 50,
                  child: ElevatedButton(
                    onPressed: () => providerHome.addItemDependent(),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: ThemeApp.secondary,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 160,
              alignment: Alignment.center,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: providerHome.dependentsName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 350,
                          child: FlatInputRoundedOutlinedFieldLight(
                            readOnly: false,
                            hintText: "Beneficiario ${index + 1}",
                            widgetWidth: 350,
                            myController: providerHome.dependentsName[index],
                            onChanged: (value) {
                              // print("Change");
                            },
                            onSubmitted: ((value) {}),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Center(
                          child: SizedBox(
                            width: 175,
                            child: DropdownButton<String>(
                              value: providerHome.dependentsRelation[index],
                              elevation: 16,
                              style: const TextStyle(color: ThemeApp.primary),
                              underline: Container(
                                height: 1,
                                color: ThemeApp.secondary,
                              ),
                              onChanged: (newValue) => providerHome
                                  .changeDependentsRelation(index, newValue),
                              items: providerHome.dependentsRelationship
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 100,
                          child: Center(
                            child: Text(
                              providerHome.dependentsAge[index],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        index == providerHome.dependentsName.length - 1
                            ? SizedBox(
                                width: 50,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      providerHome.removeItemDependent(),
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(8),
                                    backgroundColor:
                                        ThemeApp.primary, // <-- Splash color
                                  ),
                                  child: const Icon(Icons.remove,
                                      color: Colors.white),
                                ),
                              )
                            : const SizedBox(width: 50),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: 550,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeApp.secondary),
                onPressed: () {
                  // providerHome.dependentsName = [TextEditingController()];
                  // providerHome.dependentsRelation = ['HIJO/A'];
                  // providerHome.dependentsAge = ['100 %'];
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              if (providerHome.systemVariables['screen'] != 'Beneficiarios')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeApp.dialogsTxt),
                  onPressed: () {
                    providerHome.dependentsName = [TextEditingController()];
                    providerHome.dependentsRelation = ['HIJO/A'];
                    providerHome.dependentsAge = ['100 %'];
                    providerHome.dependentsSaved = true;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Continuar sin Beneficiarios'),
                ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: ThemeApp.primary),
                onPressed: () async {
                  if (!providerHome.validateDialog()) {
                    return;
                  }
                  Navigator.of(context).pop();
                  if (providerHome.systemVariables['screen'] ==
                      'Beneficiarios') {
                    /* await providerHome.updateClientBenefit(); */
                    await providerHome.updateBenefit();
                  } else {
                    providerHome.dependentsSaved = true;
                  }
                },
                child: const Text('Guardar Beneficiarios'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
