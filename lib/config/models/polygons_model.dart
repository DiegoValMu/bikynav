import 'dart:convert';

class PolygonsResponse {
    final List<Feature> features;
    final String type;

    PolygonsResponse({
        required this.features,
        required this.type,
    });

    factory PolygonsResponse.fromJson(String str) => PolygonsResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PolygonsResponse.fromMap(Map<String, dynamic> json) => PolygonsResponse(
        features: List<Feature>.from(json["features"].map((x) => Feature.fromMap(x))),
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "features": List<dynamic>.from(features.map((x) => x.toMap())),
        "type": type,
    };
}

class Feature {
    final Properties properties;
    final Geometry geometry;
    final String type;

    Feature({
        required this.properties,
        required this.geometry,
        required this.type,
    });

    factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        properties: Properties.fromMap(json["properties"]),
        geometry: Geometry.fromMap(json["geometry"]),
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "properties": properties.toMap(),
        "geometry": geometry.toMap(),
        "type": type,
    };
}

class Geometry {
    final List<List<List<double>>> coordinates;
    final String type;

    Geometry({
        required this.coordinates,
        required this.type,
    });

    factory Geometry.fromJson(String str) => Geometry.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        coordinates: List<List<List<double>>>.from(json["coordinates"].map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x?.toDouble())))))),
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
        "type": type,
    };
}

class Properties {
    final double fillOpacity;
    final String fillColor;
    final double opacity;
    final String fill;
    final double propertiesFillOpacity;
    final String color;
    final int contour;
    final String metric;

    Properties({
        required this.fillOpacity,
        required this.fillColor,
        required this.opacity,
        required this.fill,
        required this.propertiesFillOpacity,
        required this.color,
        required this.contour,
        required this.metric,
    });

    factory Properties.fromJson(String str) => Properties.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Properties.fromMap(Map<String, dynamic> json) => Properties(
        fillOpacity: json["fill-opacity"]?.toDouble(),
        fillColor: json["fillColor"],
        opacity: json["opacity"]?.toDouble(),
        fill: json["fill"],
        propertiesFillOpacity: json["fillOpacity"]?.toDouble(),
        color: json["color"],
        contour: json["contour"],
        metric: json["metric"],
    );

    Map<String, dynamic> toMap() => {
        "fill-opacity": fillOpacity,
        "fillColor": fillColor,
        "opacity": opacity,
        "fill": fill,
        "fillOpacity": propertiesFillOpacity,
        "color": color,
        "contour": contour,
        "metric": metric,
    };
}
