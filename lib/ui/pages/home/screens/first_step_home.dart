import 'package:flutter/material.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/button_give_me_five.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/dialog_dependents.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/table_plans_home.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class FirstStepHome extends StatefulWidget {
  const FirstStepHome({super.key});

  @override
  State<FirstStepHome> createState() => _FirstStepHomeState();
}

class _FirstStepHomeState extends State<FirstStepHome> {
  List<Widget> fruits = <Widget>[Text('Mensual'), Text('Anual')];

  final List<bool> _selectedFruits = <bool>[true, false];
  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    final double debito =
        providerHome.systemVariables['client'].sdtValordebitado;
    final String debitoFormated = providerHome.getDecimalFormat(
        providerHome.systemVariables['client'].sdtValordebitado);

    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: NumberStepper(
            numbers: providerHome.systemVariables['plansToShow'].isEmpty &&
                    debito == 0
                ? const <int>[1]
                : const <int>[1, 2],
            activeStepColor: ThemeApp.primary,
            activeStep: 0,
            enableStepTapping: false,
            stepColor: ThemeApp.backgroundColor,
            enableNextPreviousButtons: false,
            onStepReached: (index) => providerHome.changeScreen(index + 1),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                providerHome.getTextRegularized(1),
                style: ThemeApp.secondary23_900,
              ),
              Container(
                width: 600,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ThemeApp.secondary,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical:
                          double.parse(providerHome.getTextRegularized(3))),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            providerHome.systemVariables['client'].sdtGenero ==
                                    "Masculino"
                                ? "Soci@ "
                                : "Soci@ ",
                            style: ThemeApp.white18,
                          ),
                          Text(
                            providerHome
                                .systemVariables['client'].sdtPrimerNombre,
                            style: ThemeApp.white18_900,
                          ),
                        ],
                      ),
                      providerHome.systemVariables['plansToShow'].isEmpty &&
                              debito == 0
                          ? Text(
                              providerHome.calculateAgeRule()[0] <= 0 &&
                                      providerHome.calculateAgeRule()[1] <= 0 &&
                                      providerHome.calculateAgeRule()[2] <= 0
                                  ? "Usted es un usuario menor a un día de nacido"
                                  : "Usted es un usuario de la tercera edad",
                              style: ThemeApp.white20_800,
                            )
                          : Column(
                              children: [
                                if (providerHome.getTextRegularized(2) != '')
                                  Text(
                                    providerHome.getTextRegularized(2),
                                    style: ThemeApp.white18,
                                  ),
                                if (providerHome
                                        .systemFlags['clientPlanMajor'] ==
                                    false)
                                  Text(
                                    debito == 0
                                        ? "¿Desea acceder a los beneficios?"
                                        : "¿Mejoramos sus beneficios?",
                                    style: ThemeApp.white20_800,
                                  ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              providerHome.systemFlags['clientPlanMajor'] == false
                  ? Container(
                      width: 600,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ThemeApp.primary,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Débito Actual: ",
                              style: ThemeApp.white18),
                          Text(
                            "\$ $debitoFormated",
                            style: ThemeApp.white18_900,
                          ),
                          const SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.white,
                              thickness: 2,
                              width: 20,
                            ),
                          ),
                          const Text("Plan: ", style: ThemeApp.white18),
                          Text(
                            providerHome.getPlanName(),
                            style: ThemeApp.white18_900,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      width: 600,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Puede disfrutar de sus beneficios',
                                overflow: TextOverflow.ellipsis,
                                style: ThemeApp.primary20,
                              ),
                              Text(
                                'en el Plan ${providerHome.getPlanName()}',
                                overflow: TextOverflow.ellipsis,
                                style: ThemeApp.primary20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              if (providerHome.systemVariables['plansToShow'].isEmpty &&
                  debito == 0)
                Container(
                  width: 600,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ThemeApp.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Por condiciones de asegurabilidad de la póliza, no aplica para la contratación del Seguro de Vida",
                    style: ThemeApp.white18,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (!(providerHome.systemVariables['plansToShow'].isEmpty &&
                      debito == 0) &&
                  providerHome.systemFlags['clientPlanMajor'] == false)
                Container(
                    child: Column(
                  children: [
                    ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        if (index == 0) {
                          setState(() {
                            _selectedFruits[0] = true;
                            _selectedFruits[1] = false;
                          });

                          providerHome.systemVariables['formaPago'] = "Mensual";
                        } else {
                          setState(() {
                            _selectedFruits[0] = false;
                            _selectedFruits[1] = true;
                          });

                          providerHome.systemVariables['formaPago'] = "Anual";
                        }
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: ThemeApp.secondary,
                      selectedColor: ThemeApp.primary,
                      fillColor: ThemeApp.secondaryLight,
                      color: ThemeApp.secondary,
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: _selectedFruits,
                      children: fruits,
                    ),
                    TablePlansHome(),
                  ],
                )),
              if (providerHome.systemFlags['clientPlanMajor'] == true &&
                  debito != 0)
                const ButtonGiveMeFive(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => providerHome.giveMeFive(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeApp.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          SizedBox(width: 10),
                          Text("Salir sin Guardar"),
                        ],
                      ),
                    ),
                  ),
                  if (providerHome.systemFlags['clientExistsInDB'] == true &&
                      debito != 0 &&
                      providerHome.systemFlags['clientCanceled'] == false)
                    ElevatedButton(
                      onPressed: () async {
                        providerHome.systemVariables['screen'] =
                            'Beneficiarios';
                        providerHome.dependentsSaved = false;
                        await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => const DialogDependents(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeApp.primary,
                      ),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.people,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(width: 10),
                          Text("Actualizar beneficiarios"),
                        ],
                      ),
                    ),
                  if (debito != 0)
                    SizedBox(
                      height: 35,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () => providerHome.cancelPlan(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeApp.secondary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.cancel_outlined, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Anular Plan"),
                          ],
                        ),
                      ),
                    ),
                  if (providerHome.systemVariables['plansToShow'].isEmpty &&
                      debito == 0)
                    const ButtonGiveMeFive()
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
