import 'package:bikynav/features/bikes/app/services/bike_services.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../../nav/app/helpers/helpers.dart';

class UpdateBikeDataScreen extends StatelessWidget {
  final bike; // Recibe un objeto Bikes

  const UpdateBikeDataScreen({super.key, required this.bike});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: _buildAppBar(context),
        ),
      ),
      body: _RegisterBikeForm(bike: bike),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
        onPressed: (){
          _confirmDeleteBike(context, bike);
        }, 
        icon: Icon( Icons.delete, color: Colors.red,) ),
      ],
      title: const Text('Editar Información'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }

  void _confirmDeleteBike(BuildContext context, bike) {
    final bikeServices = Provider.of<BikeServices>(context, listen: false);
  
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar bicicleta'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¿Estás seguro de que deseas eliminar tu bicicleta? Esta acción no se puede deshacer.',
              ),
              const SizedBox(height: 16),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  showLoadingMessage(context);
                  await bikeServices.deleteBike( bike.id! );
                  hideLoadingMessage(context);
  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Bicicleta eliminado',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  context.push('/');
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error al eliminar la cuenta: $error',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  
                } finally {
                  Navigator.of(context).pop(); 
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

}

class _RegisterBikeForm extends StatefulWidget {
  final bike; // Recibimos bike como argumento
  const _RegisterBikeForm({super.key, this.bike});

  @override
  State<_RegisterBikeForm> createState() => _RegisterBikeFormState();
}

class _RegisterBikeFormState extends State<_RegisterBikeForm> with WidgetsBindingObserver {
  late TextEditingController etiquetaController;
  late TextEditingController marcaController;
  late TextEditingController modeloController;
  late TextEditingController numeroDeSerieController;
  
  void _initializeControllers() {

    etiquetaController = TextEditingController(text: widget.bike.etiqueta);
    marcaController = TextEditingController(text: widget.bike.marca);
    modeloController = TextEditingController(text: widget.bike.modelo ?? '');
    numeroDeSerieController = TextEditingController(text: widget.bike.codigoSerie ?? '');

    selectedColorPrincipal = widget.bike.colorPrincipal;
    selectedTipo = widget.bike.tipo;
    selectedAro = widget.bike?.aro;
    selectedModeloCuadro = widget.bike?.modeloCuadro;
    selectedTalla = widget.bike?.talla;

  }

  List<String> aro = ['650C (26")', '27,5"', '700C (28")', '29"'];
  List<String> tipo = ['MTB', 'Ruta', 'Urbana'];
  List<String> modeloCuadro = ['Femenino', 'Masculino','Unisex'];
  List<String> talla = ['S', 'M', 'M/L', 'L', 'XL'];

  List<String> colores = [
    'Rojo', 'Azul', 'Verde', 'Amarillo', 'Negro', 'Blanco', 'Naranja', 'Morado'
  ];

  String? selectedAro;
  String? selectedTipo;
  String? selectedModeloCuadro;
  String? selectedTalla;
  String? selectedColorPrincipal;

  bool _isKeyboardVisible = false; 

 bool _isBasicInfoExpanded = true; 
  bool _isTechnicalInfoExpanded = false;

  // Controladores para ExpansionTile
  final ExpansionTileController _basicInfoController = ExpansionTileController();
  final ExpansionTileController _technicalInfoController = ExpansionTileController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addObserver(this);
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
    final userServices = Provider.of<UserServices>(context, listen: false);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only( top: 16 ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
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
                    padding: const EdgeInsets.symmetric( horizontal:  16.0),
                    child: ExpansionTile(
                      leading: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){}, 
                        icon: const Icon( Icons.info )),
                      title: const Text(
                        'Información básica',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: _basicInfoController,
                      initiallyExpanded: _isBasicInfoExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _isBasicInfoExpanded = expanded;
                          if (expanded) {
                            _technicalInfoController.collapse();  // Colapsa el otro ExpansionTile
                            _isTechnicalInfoExpanded = false;
                          }
                        });
                      },
                      maintainState: true,
                      tilePadding: EdgeInsets.zero, // Quita el padding del encabezado
                      childrenPadding: EdgeInsets.zero, // Elimina el padding extra de los hijos
                      collapsedBackgroundColor: Colors.white, // Asegura el fondo blanco cerrado
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      children: [
                        (_isBasicInfoExpanded)
                        ? FadeInDown(child: _basicFields())
                        : FadeOut( child: _basicFields() ),
                      ]
                    ),
                  )
                ),
                
                const SizedBox(height: 10),

                Container(
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
                      leading: IconButton(
                        onPressed: (){}, 
                        icon: const Icon( Icons.build)),
                      title: const Text(
                        'Información técnica',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: _technicalInfoController,
                      initiallyExpanded: _isTechnicalInfoExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _isTechnicalInfoExpanded = expanded;
                          if (expanded) {
                            _basicInfoController.collapse();  // Colapsa el otro ExpansionTile
                            _isBasicInfoExpanded = false;
                          }
                        });
                      },
                      maintainState: true,
                      tilePadding: EdgeInsets.zero, // Quita el padding del encabezado
                      childrenPadding: EdgeInsets.zero, // Elimina el padding extra de los hijos
                      collapsedBackgroundColor: Colors.white, // Asegura el fondo blanco cerrado
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      children: [
                        (_isTechnicalInfoExpanded)
                        ? FadeInDown(child: _technicalFields())
                        : FadeOutUp(child: _technicalFields()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        (_isKeyboardVisible)
        ? Text('')
        : Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric( vertical: 10, horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                child: const Text('Guardar'),
                onPressed: () async {

                  final etiqueta = etiquetaController.text.trim();
                  final marca = marcaController.text.trim();
                  final modelo = modeloController.text.trim();
                  final codigoSerie = numeroDeSerieController.text.trim();
              
                  final bike = <String, dynamic>{
                    'etiqueta': etiqueta,
                    'marca': marca,
                    'modelo': modelo,
                    'codigo_serie': codigoSerie,
                    'color_principal': selectedColorPrincipal,
                    'tipo': selectedTipo,
                    'aro': selectedAro,
                    'modelo_cuadro': selectedModeloCuadro,
                    'talla': selectedTalla,
                    'usuario': userServices.usuario.id
                  };
              
                  try {
                    final bikeServices = Provider.of<BikeServices>(context, listen: false);
                    await bikeServices.bikeRegister(bike);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Problemas con el servicio $e")),
                    );
                    Navigator.of(context).pop();
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Bicicleta registrada correctamente")),
                  );
                  Navigator.pushNamed(context, '/');
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Column _technicalFields() {
    return Column(
      children: [
        const Divider(),
        CustomTextFormField(
          controller: numeroDeSerieController,
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
          value: selectedTipo,
          items: tipo
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (value) {
            selectedTipo = value; // Si necesitas actualizar un valor, hazlo aquí
          },
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
          value: selectedAro,
          items: aro
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (value) {
            selectedAro = value;
          },
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Modelo de cuadro',
            prefixIcon: Icon(
              selectedModeloCuadro == 'Femenino'
                  ? Icons.female
                  : selectedModeloCuadro == 'Masculino'
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
          value: selectedModeloCuadro,
          items: modeloCuadro
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (value) {
            selectedModeloCuadro = value;
          },
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
          value: selectedTalla,
          items: talla
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (value) {
            selectedTalla = value;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Column _basicFields() {
    return Column(
      children: [
        const Divider(),
        CustomTextFormField(
          controller: etiquetaController,
          icon: Icons.edit,
          placeholder: 'Etiqueta',
          inputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          controller: marcaController,
          icon: Icons.directions_bike,
          placeholder: 'Marca',
          inputType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          controller: modeloController,
          icon: Icons.build,
          placeholder: 'Modelo',
          inputType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Color principal',
            prefixIcon: const Icon(Icons.colorize_sharp, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          value: selectedColorPrincipal,
          items: colores
              .map((color) => DropdownMenuItem(
                    value: color,
                    child: Text(color),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedColorPrincipal = value;
            });
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

}
