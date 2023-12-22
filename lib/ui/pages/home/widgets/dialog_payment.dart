import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/toast_notifications.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class DialogPayment extends StatefulWidget {
  const DialogPayment({super.key});

  @override
  State<DialogPayment> createState() => _DialogPaymentState();
}

class _DialogPaymentState extends State<DialogPayment> {
  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const SizedBox(
        width: 300,
        child: Center(
          child: Text(
            'Forma de Pago',
            style: ThemeApp.primary20Bold,
          ),
        ),
      ),
      content: SizedBox(
        height: 95,
        child: ReactiveForm(
          formGroup: providerHome.formPayment,
          child: Column(
            children: <Widget>[
              const Text('¿Desea que se realice el débito de forma anual?'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Sí'),
                  ReactiveRadio(
                      formControlName: 'paymentYearly',
                      value: true,
                      onChanged: (value) => setState(() {})),
                  const SizedBox(width: 40),
                  const Text('No'),
                  ReactiveRadio(
                      formControlName: 'paymentYearly',
                      value: false,
                      onChanged: (value) => setState(() {
                            
                          })),
                ],
              ),
              const SizedBox(height: 20),
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
            if (providerHome.paymentMethod){
              providerHome.systemVariables['formaPago'] =
                "Anual";
                var valorMensual = providerHome.systemVariables['valueToDebit'];
                var valorAnual = double.parse(valorMensual)*12;
                providerHome.systemVariables['valueToDebit'] = valorAnual.toStringAsFixed(2);
            } else{
              providerHome.systemVariables['formaPago'] =
                "Mensual";
            }
            
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
