import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'package:bikynav/features/bikes/app/services/bike_services.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:bikynav/features/bikes/presentation/views/basic_bike_form_fields.dart';
import 'package:bikynav/features/bikes/presentation/views/technical_bike_form_fields.dart';

class BikeForm extends StatefulWidget {
  final dynamic bike; // Puede ser null para añadir, o un objeto Bike para editar
  final String buttonText;
  final Function(Map<String, dynamic>) onSubmit;

  const BikeForm({
    super.key,
    this.bike,
    required this.buttonText,
    required this.onSubmit,
  });

  @override
  State<BikeForm> createState() => _BikeFormState();
}

class _BikeFormState extends State<BikeForm> with WidgetsBindingObserver {
  late TextEditingController etiquetaController;
  late TextEditingController marcaController;
  late TextEditingController modeloController;
  late TextEditingController numeroDeSerieController;

  String? selectedAro;
  String? selectedTipo;
  String? selectedModeloCuadro;
  String? selectedTalla;
  String? selectedColorPrincipal;

  bool _isKeyboardVisible = false;
  bool _isBasicInfoExpanded = true;
  bool _isTechnicalInfoExpanded = false;

  final ExpansionTileController _basicInfoController = ExpansionTileController();
  final ExpansionTileController _technicalInfoController = ExpansionTileController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addObserver(this);
  }

  void _initializeControllers() {
    etiquetaController = TextEditingController(text: widget.bike?.etiqueta ?? '');
    marcaController = TextEditingController(text: widget.bike?.marca ?? '');
    modeloController = TextEditingController(text: widget.bike?.modelo ?? '');
    numeroDeSerieController = TextEditingController(text: widget.bike?.codigoSerie ?? '');

    selectedColorPrincipal = widget.bike?.colorPrincipal;
    selectedTipo = widget.bike?.tipo;
    selectedAro = widget.bike?.aro;
    selectedModeloCuadro = widget.bike?.modeloCuadro;
    selectedTalla = widget.bike?.talla;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildBasicInfoExpansionTile(),
                const SizedBox(height: 10),
                _buildTechnicalInfoExpansionTile(),
              ],
            ),
          ),
        ),
        if (!_isKeyboardVisible) _buildBottomButton(context),
      ],
    );
  }

  Widget _buildBasicInfoExpansionTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ExpansionTile(
          leading: const Icon(Icons.info),
          title: const Text(
            'Información básica',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          controller: _basicInfoController,
          initiallyExpanded: _isBasicInfoExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isBasicInfoExpanded = expanded;
              if (expanded) {
                _technicalInfoController.collapse();
                _isTechnicalInfoExpanded = false;
              }
            });
          },
          maintainState: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          children: [
            FadeInDown(
              child: BasicFormFields(
                etiquetaController: etiquetaController,
                marcaController: marcaController,
                modeloController: modeloController,
                selectedColorPrincipal: selectedColorPrincipal,
                onColorPrincipalChanged: (value) =>
                    setState(() => selectedColorPrincipal = value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalInfoExpansionTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ExpansionTile(
          leading: const Icon(Icons.build),
          title: const Text(
            'Información técnica',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          controller: _technicalInfoController,
          initiallyExpanded: _isTechnicalInfoExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isTechnicalInfoExpanded = expanded;
              if (expanded) {
                _basicInfoController.collapse();
                _isBasicInfoExpanded = false;
              }
            });
          },
          maintainState: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          children: [
            FadeInDown(
              child: TechnicalFormFields(
                numeroDeSerieController: numeroDeSerieController,
                selectedTipo: selectedTipo,
                selectedAro: selectedAro,
                selectedModeloCuadro: selectedModeloCuadro,
                selectedTalla: selectedTalla,
                onTipoChanged: (value) => setState(() => selectedTipo = value),
                onAroChanged: (value) => setState(() => selectedAro = value),
                onModeloCuadroChanged: (value) => setState(() => selectedModeloCuadro = value),
                onTallaChanged: (value) => setState(() => selectedTalla = value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final userServices = Provider.of<UserServices>(context, listen: false);
    final bikeServices = Provider.of<BikeServices>(context, listen: false);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            child: Text(widget.buttonText),
            onPressed: () async {
              final bikeData = <String, dynamic>{
                'etiqueta': etiquetaController.text.trim(),
                'marca': marcaController.text.trim(),
                'modelo': modeloController.text.trim(),
                'codigo_serie': numeroDeSerieController.text.trim(),
                'color_principal': selectedColorPrincipal,
                'tipo': selectedTipo,
                'aro': selectedAro,
                'modelo_cuadro': selectedModeloCuadro,
                'talla': selectedTalla,
                'usuario': userServices.usuario.id,
              };
              widget.onSubmit(bikeData);
            },
          ),
        ),
      ),
    );
  }
}