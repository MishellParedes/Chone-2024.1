import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class ButtonGeneratePinHome extends StatelessWidget {
  const ButtonGeneratePinHome({super.key});

  @override
  Widget build(BuildContext context) {
    final providerHome = Provider.of<ProviderHome>(context);
    return providerHome.pinSended
        ? providerHome.pinValidating
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    width: 250,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: ThemeApp.mainHeaderAccentColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Vigencia del PIN: ${providerHome.timerPIN('m')}:${providerHome.timerPIN('s')}",
                      style: ThemeApp.white18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Pinput(
                    length: 5,
                    defaultPinTheme: ThemeApp.defaultPinTheme,
                    focusedPinTheme: ThemeApp.focusedPinTheme,
                    submittedPinTheme: ThemeApp.submittedPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) => providerHome.validatePIN(pin),
                    controller: providerHome.pinController,
                  )
                ],
              )
        : SizedBox(
            height: 35,
            width: 150,
            child: ElevatedButton(
              onPressed: () => providerHome.generatePin(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeApp.primary,
              ),
              child: const Text("Generar PIN"),
            ),
          );
  }
}
