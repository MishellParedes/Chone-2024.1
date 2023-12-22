import 'package:flutter/material.dart';
import 'package:sapo_benefica/data/models/client_model.dart';
import 'package:sapo_benefica/data/models/plans_model.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CardPlanSelected extends StatelessWidget {
  const CardPlanSelected({required this.card, super.key});

  final int card;

  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    final Client client = providerHome.systemVariables['client'];
    final String names = '${client.sdtPrimerNombre} ${client.sdtSegundoNombre}';
    final String lastNames =
        '${client.sdtPrimerApellido} ${client.sdtSegundoApellido}';
    final String planName =
        Plan.plans[providerHome.systemVariables['selectedPlan']]['name'];
    final String planValue =
        '\$ ${providerHome.getDecimalFormat(Plan.plans[providerHome.systemVariables['selectedPlan']]['value'])}';
    final String transaction = providerHome.systemVariables['tipoTransaccion'];
    final String debit =
        '\$ ${providerHome.systemVariables['valueToDebit'].replaceAll('.', ',')}';
    final String validity =
        '${providerHome.systemVariables['fechaInicioVigencia']} - ${providerHome.systemVariables['fechaFinVigencia']}';
    return card == 1
        ? Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  Container(
                    width: 180,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ThemeApp.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Datos del Socio',
                      style: ThemeApp.white18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          cardLabelsColumn('Nombres: ', 1),
                          cardLabelsColumn('Apellidos: ', 1),
                          cardLabelsColumn('Cédula: ', 1),
                          cardLabelsColumn('Cuenta: ', 1),
                          cardLabelsColumn('Celular: ', 1),
                          cardLabelsColumn('Correo: ', 1),
                          // cardLabelsColumn('Nuevo Celular: ', 3),
                          cardLabelsColumn('Nuevo Correo: ', 3),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 5),
                            cardLabelsColumn(names, 2),
                            cardLabelsColumn(lastNames, 2),
                            cardLabelsColumn(client.sdtNumeroIdentificacion, 2),
                            cardLabelsColumn(client.sdtNumeroCuenta, 2),
                            cardLabelsColumn(client.sdtTelefonoCelular, 2),
                            cardLabelsColumn(client.sdtEmail, 2),
                            ReactiveForm(
                              formGroup: providerHome.formGroupSecondStep,
                              child: Column(
                                children: [
                                  // SizedBox(
                                  //   height: 30,
                                  //   child: ReactiveTextField(
                                  //     formControlName: 'nuevo_celular',
                                  //     decoration: ThemeApp.inputDecoration(''),
                                  //     readOnly: providerHome.pinSended,
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 2),
                                  SizedBox(
                                    height: 30,
                                    child: ReactiveTextField(
                                      formControlName: 'nuevo_correo',
                                      decoration: ThemeApp.inputDecoration(''),
                                      readOnly: providerHome.pinSended,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  /* SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: ReactiveTextField(
                                              readOnly: true,
                                              formControlName: "numero_diptico",
                                              decoration: ThemeApp
                                                  .inputDecorationReadOnly("")),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () =>
                                              providerHome.getDipticoNumber(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ThemeApp.primary,
                                          ),
                                          child: SizedBox(
                                            width: 120,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                providerHome.isFetching != 1
                                                    ? const Text(
                                                        'Leer Fotografía')
                                                    : const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ), */
                                  const SizedBox(height: 2),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Container(
                        width: 180,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ThemeApp.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Datos del Plan',
                          style: ThemeApp.white18,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              cardLabelsColumn('Plan: ', 1),
                              cardLabelsColumn('Valor: ', 1),
                              cardLabelsColumn('Estado: ', 1),
                              cardLabelsColumn('Valor a debitar: ', 1),
                              cardLabelsColumn('Vigencia: ', 1),
                            ],
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 12),
                                cardLabelsColumn(
                                    planName.replaceAll("\n", " - "), 2),
                                cardLabelsColumn(planValue, 2),
                                cardLabelsColumn(transaction, 2),
                                cardLabelsColumn(debit, 2),
                                cardLabelsColumn(validity, 2),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Widget cardLabelsColumn(String text, int theme) {
    return SizedBox(
      height: 35,
      child: theme == 1
          ? Center(
              child: Text(
                text,
                style: ThemeApp.black18_600,
              ),
            )
          : theme == 2
              ? Text(
                  text,
                  style: ThemeApp.primary18Bold,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                )
              : theme == 3
                  ? Center(
                      child: Text(
                        text,
                        style: ThemeApp.secondary18_600,
                      ),
                    )
                  : Text(text),
    );
  }
}
