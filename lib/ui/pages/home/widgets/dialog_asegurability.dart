import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/toast_notifications.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class DialogAsegurability extends StatefulWidget {
  const DialogAsegurability({super.key});

  @override
  State<DialogAsegurability> createState() => _DialogAsegurabilityState();
}

class _DialogAsegurabilityState extends State<DialogAsegurability> {
  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const SizedBox(
        width: 300,
        child: Center(
          child: Text(
            'Tarjeta de Asegurabilidad',
            style: ThemeApp.primary20Bold,
          ),
        ),
      ),
      content: SizedBox(
        height: 135,
        child: ReactiveForm(
          formGroup: providerHome.formAsegurability,
          child: Column(
            children: <Widget>[
              const Text('¿Tiene enfermedad?'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Sí'),
                  ReactiveRadio(
                      formControlName: 'haveDisease',
                      value: true,
                      onChanged: (value) => setState(() {})),
                  const SizedBox(width: 40),
                  const Text('No'),
                  ReactiveRadio(
                      formControlName: 'haveDisease',
                      value: false,
                      onChanged: (value) => setState(() {
                            providerHome.diseaseName = '';
                          })),
                ],
              ),
              const SizedBox(height: 20),
              if (providerHome.haveDisease)
                SizedBox(
                  width: 300,
                  child: ReactiveTextField(
                      formControlName: 'diseaseName',
                      decoration:
                          ThemeApp.inputDecoration('Nombre de la enfermedad')),
                )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            providerHome.systemVariables['enfermedadGuardada'] = false;
          },
          child: const Text(
            'Cambiar de plan',
            style: ThemeApp.secondary18_600,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeApp.quaternary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (providerHome.diseaseName.isEmpty && providerHome.haveDisease) {
              ToastNotifications.showBadNotification(
                  msg: 'Ingrese la enfermedad');
              return;
            }
            providerHome.systemVariables['enfermedadGuardada'] = true;
            providerHome.systemVariables['enfermedades'] =
                providerHome.diseaseName;
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Guardar',
              style: ThemeApp.white18_600,
            ),
          ),
        ),
      ],
    );
  }
}
