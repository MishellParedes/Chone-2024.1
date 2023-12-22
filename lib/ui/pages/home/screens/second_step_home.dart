import 'package:flutter/material.dart';
import 'package:sapo_benefica/data/aws/notification_controller.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/card_plan_selected.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/button_generate_pin.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class SecondStepHome extends StatelessWidget {
  const SecondStepHome({super.key});

  @override
  Widget build(BuildContext context) {
    final providerHome = Provider.of<ProviderHome>(context);
    final String screen = providerHome.systemVariables['screen'];
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: NumberStepper(
            numbers: const <int>[1, 2],
            activeStepColor: ThemeApp.primary,
            activeStep: 1,
            enableStepTapping: false,
            stepColor: ThemeApp.backgroundColor,
            enableNextPreviousButtons: false,
            onStepReached: (index) => providerHome.changeScreen(index + 1),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 600,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: ThemeApp.secondary,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    providerHome.systemVariables['client'].sdtGenero ==
                            'Masculino'
                        ? 'Soci@ '
                        : 'Soci@ ',
                    style: ThemeApp.white18,
                  ),
                  Text(
                    providerHome.systemVariables['client'].sdtPrimerNombre,
                    style: ThemeApp.white18_900,
                  ),
                ],
              ),
              Text(
                screen == 'Plan Seleccionado'
                    ? '¿Actualizamos sus datos?'
                    : screen == 'Beneficiarios'
                        ? '¿Actualizamos sus beneficiarios?'
                        : screen == 'Anulación'
                            ? '¿Confirma que desea anular su plan?'
                            : '',
                style: ThemeApp.white20_800,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              screen == 'Plan Seleccionado'
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Flexible(
                                  flex: 60, child: CardPlanSelected(card: 1)),
                              SizedBox(width: 10),
                              Flexible(
                                  flex: 50, child: CardPlanSelected(card: 2)),
                            ],
                          ),
                        ),
                      ],
                    )
                  : screen == 'Anulación'
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              width: 600,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Motivo",
                                            style: ThemeApp.primary20Bold,
                                          ),
                                          SizedBox(width: 10),
                                          DropdownButton<String>(
                                            value:
                                                providerHome.reasonToAnulment,
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: ThemeApp.primary),
                                            underline: Container(
                                              height: 1,
                                              color: ThemeApp.secondary,
                                            ),
                                            onChanged: (newValue) => 
                                              providerHome
                                                  .changeReasonToAnulment(
                                                      newValue),
                                            items: [
                                              "El socio no autorizó el débito",
                                              "El socio y/o sus dependientes no ha hecho uso del seguro"
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            '- Recibirá un pin de confirmación en el número ',
                                            style: ThemeApp.primary20,
                                          ),
                                          Text(
                                            providerHome
                                                .systemVariables['client']
                                                .sdtTelefonoCelular,
                                            style: ThemeApp.primary20Bold,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                    value: providerHome.haveAnotherPhone,
                                    onChanged: (bool? value) {
                                      providerHome
                                          .changeHaveAnotherPhone(value!);
                                    }),
                                const SizedBox(width: 10),
                                const Text(
                                  'Tiene otro número',
                                  style: ThemeApp.primary20,
                                )
                              ],
                            ),
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
              SizedBox(
                height: 110,
                child: providerHome.haveAnotherPhone &&
                        !providerHome.pinSended &&
                        !providerHome.pinValidating
                    ? Center(
                        child: SizedBox(
                          height: 35,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              providerHome.anulPlan = true;
                              providerHome.validatePIN(OtpController()
                                  .generateCode(providerHome.numCed)
                                  .toString());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeApp.primary,
                            ),
                            child: const Text('Anular'),
                          ),
                        ),
                      )
                    : providerHome.haveAnotherPhone && providerHome.anulPlan
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Center(child: ButtonGeneratePinHome()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
