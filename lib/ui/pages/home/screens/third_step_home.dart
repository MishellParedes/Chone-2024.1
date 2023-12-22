import 'package:flutter/material.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/button_give_me_five.dart';
import 'package:provider/provider.dart';
import 'package:sapo_benefica/data/models/plans_model.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/card_points_user.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/dialog_downloads.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class ThirdStepHome extends StatelessWidget {
  const ThirdStepHome({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    final String screen = providerHome.systemVariables['screen'];
    final String name =
        '${providerHome.systemVariables['client'].sdtGenero == 'Masculino' ? 'Soci@' : 'Soci@'} ${providerHome.systemVariables['client'].sdtPrimerNombre} ${providerHome.systemVariables['client'].sdtPrimerApellido}';
    return Container(
      decoration: screen == 'Débito incorrecto'
          ? const BoxDecoration()
          : const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/confetti-29.gif'),
                fit: BoxFit.cover,
              ),
            ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            screen == 'Plan Seleccionado'
                ? '¡Regularizacion Exitosa!'
                : screen == 'Beneficiarios'
                    ? '¡Actualización Exitosa!'
                    : screen == 'Anulación'
                        ? '¡Anulación Exitosa!'
                        : screen == 'Asesoría'
                            ? '¡Solicitud atendida!'
                            : screen == 'Débito incorrecto'
                                ? '¡Error!'
                                : '',
            style: ThemeApp.secondary23_900,
          ),
          Container(
            width: 600,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            decoration: BoxDecoration(
                color: ThemeApp.secondary,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                Text(
                  screen == 'Plan Seleccionado' || screen == 'Beneficiarios'
                      ? '¡Felicidades $name!'
                      : screen == 'Anulación'
                          ? '$name su plan ha sido anulado'
                          : screen == 'Asesoría'
                              ? '$name su solicitud ha sido registrada'
                              : screen == 'Débito incorrecto'
                                  ? '$name su debito no pudo ser realizado'
                                  : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
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
                      child: screen == 'Plan Seleccionado'
                          ? Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      '- Ya cuenta con cobertura en el ',
                                      style: ThemeApp.primary20,
                                    ),
                                    Text(
                                      'PLAN ${Plan.plans[providerHome.systemVariables['selectedPlan']]['name']}',
                                      style: ThemeApp.primary20Bold,
                                    ),
                                  ],
                                ),
                                const Text(
                                  '- Su certificado fue enviado a su correo ',
                                  style: ThemeApp.primary20,
                                ),
                                Text(
                                  providerHome.nuevoCorreo != ''
                                      ? providerHome.nuevoCorreo
                                      : providerHome
                                          .systemVariables['client'].sdtEmail,
                                  style: ThemeApp.primary20Bold,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  '- Ya estás participando en el fabuloso sorteo',
                                  style: ThemeApp.primary20,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  '- ¡Un Ejecutivo se comunicará con usted para darle la bienvenida y detallar los beneficios del seguro!',
                                  style: ThemeApp.primary20,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : screen == 'Beneficiarios'
                              ? const Center(
                                  child: Text(
                                    'Ha actualizado los beneficiarios',
                                    style: ThemeApp.primary20,
                                  ),
                                )
                              : screen == 'Anulación'
                                  ? Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Ya no cuenta con cobertura de ',
                                              style: ThemeApp.primary20,
                                            ),
                                            Text(
                                              'Ningun Tipo',
                                              style: ThemeApp.primary20Bold,
                                            ),
                                          ],
                                        ),
                                        const Text(
                                          '- Su solicitud será impresa para su firma',
                                          style: ThemeApp.primary20,
                                        ),
                                      ],
                                    )
                                  : screen == 'Asesoría'
                                      ? Column(
                                          children: <Widget>[
                                            const Text(
                                              'En unos momentos un ejecutivo de Grupo Mancheno',
                                              style: ThemeApp.primary20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                const Text(
                                                  'se contactará con el socio al número ',
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
                                        )
                                      : screen == 'Débito incorrecto'
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                const Text(
                                                  'El motivo es ',
                                                  style: ThemeApp.primary20,
                                                ),
                                                Text(
                                                  providerHome.systemVariables[
                                                      'errorDebito'],
                                                  style: ThemeApp.primary20Bold,
                                                ),
                                              ],
                                            )
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                    )),
              ),
            ],
          ),
          if (screen == 'Anulación')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => providerHome.downloadFile(providerHome
                      .systemVariables['client'].sdtNumeroIdentificacion),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeApp.secondary,
                  ),
                  child: Row(
                    children: const <Widget>[
                      Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 35,
                      ),
                      SizedBox(width: 10),
                      Text("Descargar Anulación"),
                    ],
                  ),
                )
              ],
            ),
          if (['Plan Seleccionado', 'Beneficiarios'].contains(screen))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => const DialogDownloads(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeApp.secondary,
                  ),
                  child: Row(
                    children: const <Widget>[
                      Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 35,
                      ),
                      SizedBox(width: 10),
                      Text("Descargar Documentos"),
                    ],
                  ),
                )
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const <Widget>[
              Flexible(flex: 75, child: CardPointsUser()),
              Flexible(flex: 25, child: ButtonGiveMeFive()),
            ],
          ),
        ],
      ),
    );
  }
}
