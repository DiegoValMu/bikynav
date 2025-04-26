import 'dart:io';

import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/nav/config/models/places_models.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/shared/views/custom_draggable_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class CustomMarkerForm extends CustomDraggableSheet {
  final VoidCallback onCloseTap;
  final VoidCallback onRouteTap;
  
  CustomMarkerForm({
    super.key, 
    required this.onCloseTap,
    required this.onRouteTap,
  }) : super(
    minHeight: 100,
    maxHeight: 450,
    child: _CustomMarkerFormContent(onCloseTap: onCloseTap, onRouteTap: onRouteTap,),
  );
}

class _CustomMarkerFormContent extends StatefulWidget {
  final VoidCallback onCloseTap;
  final VoidCallback onRouteTap;
  
  const _CustomMarkerFormContent({
    required this.onCloseTap,
    required this.onRouteTap,
  });

  @override
  __CustomMarkerFormContentState createState() => __CustomMarkerFormContentState();
}

class __CustomMarkerFormContentState extends State<_CustomMarkerFormContent> {
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  String _selectedType = 'taller';
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    final routeServices = Provider.of<RouteServices>(context, listen: false);
    final place = routeServices.infoPlace!;
    final lat = place.geometry.coordinates[1];
    final lng = place.geometry.coordinates[0];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const DecorativeBar(),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _directionsAndClose(context, BlocProvider.of<MapBloc>(context, listen: false), place),
        ),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildTypeSelector(),
                  const SizedBox(height: 10),
                  _buildDynamicFields(),
                  const SizedBox(height: 15),
                  _buildSaveButton(context, lat, lng),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return DropdownButtonFormField<String>(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      value: _selectedType,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        labelText: 'Tipo de marcador',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), // Use your theme color
      ),
      items: const [
        DropdownMenuItem(value: 'taller', child: Text('Taller')),
        DropdownMenuItem(value: 'evento', child: Text('Evento')),
        DropdownMenuItem(value: 'punto_interes', child: Text('Punto de interés')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedType = value!;
          // Resetear el label cuando cambia el tipo
          _labelController.text = '';
        });
      },
    );
  }

  Widget _buildDynamicFields() {
    switch (_selectedType) {
      case 'taller':
        return _buildTallerFields();
      case 'evento':
        return _buildEventoFields();
      case 'punto_interes':
        return _buildPuntoInteresFields();
      default:
        return Container();
    }
  }

  Widget _buildTallerFields() {
    return Column(
      children: [
        CustomTextFormField(
          placeholder: 'Nombre del taller', 
          controller: _labelController,
          icon: Icons.build,
          inputType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          placeholder: 'Contacto del taller', 
          controller: _contactController,
          icon: Icons.phone,
          inputType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          placeholder: 'Email del taller', 
          controller: _emailController,
          icon: Icons.email,
          inputType: TextInputType.name,
        ),  
        const SizedBox(height: 10),
        CustomTextFormField(
          placeholder: 'Horario de atención', 
          controller: _scheduleController,
          icon: Icons.access_time_rounded,
          inputType: TextInputType.name,
        ),  
        const SizedBox(height: 10),
        CustomTextFormField(
          placeholder: 'Sitio web (opcional)', 
          controller: _websiteController,
          icon: Icons.web,
          inputType: TextInputType.name,
        ), 
        const SizedBox(height: 10),
        _buildImagePicker(),
      ],
    );
  }

  Widget _buildEventoFields() {
    return Column(
      children: [
        CustomTextFormField(
          placeholder: 'Nombre del evento', 
          controller: _labelController,
          icon: Icons.abc,
          inputType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          placeholder: 'Contacto del organizador', 
          controller: _contactController,
          icon: Icons.phone,
          inputType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          placeholder: 'Email del organizador', 
          controller: _emailController,
          icon: Icons.email,
          inputType: TextInputType.name,
        ),        
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  filled: true,
                  hintText: 'DD/MM/AAAA',
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.event),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), // Use your theme color
                ),
                keyboardType: TextInputType.datetime,
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Hora',
                  hintText: 'HH:MM',
                  prefixIcon: Icon(Icons.timer_outlined),
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), // Use your theme color
                ),
                
                keyboardType: TextInputType.datetime,
                onTap: () => _selectTime(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildImagePicker(),
      ],
    );
  }

  Widget _buildPuntoInteresFields() {
    return Column(
      children: [
        CustomTextFormField(
          placeholder: 'Punto de interes', 
          controller: _labelController,
          icon: Icons.abc,
          inputType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(
            filled: true,
            labelText: 'Descripción',
            hintText: 'Ej: Vista espectacular de la ciudad',
            fillColor: Colors.grey[200],
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), // Use your theme color
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 15),
        _buildImagePicker(),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () async {
            // Aquí iría la lógica para seleccionar una imagen
            // Por ejemplo:
            // final image = await ImagePicker().pickImage(source: ImageSource.gallery);
            // if (image != null) {
            //   setState(() => _imagePath = image.path);
            // }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funcionalidad de selección de imagen')),
            );
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Añadir imagen'),
        ),
        if (_imagePath != null)
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(_imagePath!)),
                fit: BoxFit.cover,

              ),
            ),
          ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    helpText: 'Seleccione una fecha',
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.white, // Fondo blanco
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor, // Color del header y botones
            onPrimary: Colors.white, // Texto sobre el color primario
            surface: Colors.white, // Fondo del calendario
            onSurface: Colors.black, // Texto del calendario
          ),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
    });
  }
}

Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.white, // Fondo blanco
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor, // Color del header y botones
            onPrimary: Colors.white, // Texto sobre el color primario
            surface: Colors.white, // Fondo del selector de hora
            onSurface: Colors.black, // Texto del selector
          ),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      _timeController.text = "${picked.hour}:${picked.minute.toString().padLeft(2, '0')}";
    });
  }
}

  Widget _buildSaveButton(BuildContext context, double lat, double lng) {
    return ElevatedButton(
      onPressed: () {
        if (_labelController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor ingresa un nombre')),
          );
          return;
        }

        // Aquí iría la lógica para guardar todos los datos
        // Puedes acceder a:
        // _selectedType (tipo de marcador)
        // Todos los controladores según el tipo seleccionado
        // _imagePath para la imagen

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Marcador guardado con éxito')),
        );

        widget.onCloseTap();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.deepPurple,
      ),
      child: const Text(
        'Guardar Marcador',
        style: TextStyle(color: Colors.white),
      ),
    );
  }


  Row _directionsAndClose(BuildContext context, MapBloc mapBloc, Feature place) {
    
    final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
    
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              visualDensity: VisualDensity.compact,
              leading: IconButton(
                onPressed: () async {
                  showLoadingMessage(context);
                  final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
                  final locationState = BlocProvider.of<LocationBloc>(context, listen: false).state;
                  final currentLocation = locationState.lastKnowlocation!;
                  
                  final endPoint = LatLng(place.geometry.coordinates[1], place.geometry.coordinates[0]);

                  if(mapBloc.state.polylines.isNotEmpty){
                    mapBloc.add(OnCancelRoute());
                    mapBloc.add(OnStopFollowingUserEvent());
                    mapBloc.state.polylines.remove('navigationRoute');
                    mapBloc.state.markers.remove('navigationStart');
                    mapBloc.state.markers.remove('navigationEnd');
                    hideLoadingMessage(context);
                    return;
                  }

                  final navigationPath = await searchBloc.getCoorsStartToEnd(
                    currentLocation, 
                    endPoint
                  );

                  await mapBloc.drawRoutePolyline(navigationPath);
                  mapBloc.add(OnInitRoute());
                  
                  hideLoadingMessage(context);
                  widget.onRouteTap();
                }, 
                icon: const Icon(Icons.directions),
                iconSize: 40,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('${place.properties.namePreferred}, ${place.properties.placeFormatted.split(',').first}', 
                  style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,),
              ),
            ),
          ),
          IconButton(
            onPressed: (){
              mapBloc.state.markers.remove('newMarker');
                searchBloc.add(AddToHistoryEvent(place));
              widget.onCloseTap();
            }, 
            icon: const Icon(Icons.close),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
            ),
          ),
          const Divider(),
        ],
      );
  }
}