import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final String? errorMessage;
  final TextInputType inputType; // Tipo de entrada
  final bool isPassword; // Indica si es un campo de contraseña
  final Function(String)? onChanged; // Función llamada cuando el valor cambia
  final TextEditingController? controller; // Controlador del campo
  final bool isFilled; // Indica si el campo tiene contenido
  final String? Function(String?)? validator; //
  final bool isNotEmpty;
  final ValueNotifier<bool> _isObscureNotifier = ValueNotifier(true); // Notificador para la visibilidad de la contraseña

  CustomTextFormField({
    super.key,
    required this.icon,
    required this.placeholder,
    this.inputType = TextInputType.text, // Por defecto es texto normal
    this.isPassword = false, // Por defecto no es una contraseña
    this.errorMessage,
    this.onChanged,
    this.controller,
    this.isFilled = false, 
    this.validator, 
    this.isNotEmpty = true, 
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isObscureNotifier,
      builder: (context, isObscure, child) {
        return TextFormField(
          controller: controller, // Asociamos el controlador al TextFormField
          onChanged: onChanged, // Propaga el cambio hacia el exterior
          validator: validator,
          keyboardType: inputType, // Define el tipo de entrada
          obscureText: isPassword ? isObscure : false, // Oculta el texto si es contraseña
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: isFilled ? Colors.green : Colors.grey),
            hintText: placeholder,
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade800),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade800),
            ),
            errorText: errorMessage,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Cambia la visibilidad de la contraseña
                      _isObscureNotifier.value = !isObscure;
                    },
                  )
                : (isFilled
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear, // Icono de limpiar
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          controller?.clear(); // Limpia el campo
                        },
                      )
                    : null),
          ),
        );
      },
    );
  }
}
