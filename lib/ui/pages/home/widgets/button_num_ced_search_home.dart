import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class InputNumCedSearchHome extends StatelessWidget {
  const InputNumCedSearchHome({super.key});

  @override
  Widget build(BuildContext context) {
    final providerHome = Provider.of<ProviderHome>(context);
    return ReactiveForm(
      formGroup: providerHome.formSearchNumCed,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: ReactiveTextField(
                  formControlName: 'num_ced',
                  decoration: ThemeApp.inputDecoration("Número de cédula"),
                  maxLength: 10,
                  onChanged: (control) => providerHome.validateNumCed(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
