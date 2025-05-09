import 'package:flutter/material.dart';
import 'package:bikynav/presentation/Navegacion/widgets/widgets.dart';

class TechnicalFormFields extends StatefulWidget {
  final TextEditingController numeroDeSerieController;
  final String? selectedAro;
  final String? selectedTipo;
  final String? selectedModeloCuadro;
  final String? selectedTalla;
  final ValueChanged<String?> onAroChanged;
  final ValueChanged<String?> onTipoChanged;
  final ValueChanged<String?> onModeloCuadroChanged;
  final ValueChanged<String?> onTallaChanged;

  const TechnicalFormFields({
    super.key,
    required this.numeroDeSerieController,
    this.selectedAro,
    this.selectedTipo,
    this.selectedModeloCuadro,
    this.selectedTalla,
    required this.onAroChanged,
    required this.onTipoChanged,
    required this.onModeloCuadroChanged,
    required this.onTallaChanged,
  });

  @override
  State<TechnicalFormFields> createState() => _TechnicalFormFieldsState();
}

class _TechnicalFormFieldsState extends State<TechnicalFormFields> {
  List<String> aro = ['650C (26")', '27,5"', '700C (28")', '29"'];
  List<String> tipo = ['MTB', 'Ruta', 'Urbana'];
  List<String> modeloCuadro = ['Femenino', 'Masculino', 'Unisex'];
  List<String> talla = ['S', 'M', 'M/L', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        CustomTextFormField(
          controller: widget.numeroDeSerieController,
          icon: Icons.qr_code_2,
          placeholder: 'Número de serie',
          inputType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Tipo',
            prefixIcon: const Icon(Icons.category, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          value: widget.selectedTipo,
          items: tipo
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: widget.onTipoChanged,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Aro',
            prefixIcon: const Icon(Icons.height, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          value: widget.selectedAro,
          items: aro
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: widget.onAroChanged,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Modelo de cuadro',
            prefixIcon: Icon(
              widget.selectedModeloCuadro == 'Femenino'
                  ? Icons.female
                  : widget.selectedModeloCuadro == 'Masculino'
                      ? Icons.male
                      : Icons.transgender,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          value: widget.selectedModeloCuadro,
          items: modeloCuadro
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: widget.onModeloCuadroChanged,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Talla',
            prefixIcon: const Icon(Icons.straighten, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          value: widget.selectedTalla,
          items: talla
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: widget.onTallaChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}