import 'dart:convert';

class TrafficResponseCycling {
    final List<Route> routes;
    final List<Waypoint> waypoints;
    final String code;
    final String uuid;

    TrafficResponseCycling({
        required this.routes,
        required this.waypoints,
        required this.code,
        required this.uuid,
    });

    factory TrafficResponseCycling.fromJson(String str) => TrafficResponseCycling.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TrafficResponseCycling.fromMap(Map<String, dynamic> json) => TrafficResponseCycling(
        routes: List<Route>.from(json["routes"].map((x) => Route.fromMap(x))),
        waypoints: List<Waypoint>.from(json["waypoints"].map((x) => Waypoint.fromMap(x))),
        code: json["code"],
        uuid: json["uuid"],
    );

    Map<String, dynamic> toMap() => {
        "routes": List<dynamic>.from(routes.map((x) => x.toMap())),
        "waypoints": List<dynamic>.from(waypoints.map((x) => x.toMap())),
        "code": code,
        "uuid": uuid,
    };
}

class Route {
    final String geometry;
    final List<Leg> legs;
    final String weightName;
    final double weight;
    final double duration;
    final double distance;

    Route({
        required this.geometry,
        required this.legs,
        required this.weightName,
        required this.weight,
        required this.duration,
        required this.distance,
    });

    factory Route.fromJson(String str) => Route.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Route.fromMap(Map<String, dynamic> json) => Route(
        geometry: json["geometry"],
        legs: List<Leg>.from(json["legs"].map((x) => Leg.fromMap(x))),
        weightName: json["weight_name"],
        weight: json["weight"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
        distance: json["distance"],
    );

    Map<String, dynamic> toMap() => {
        "geometry": geometry,
        "legs": List<dynamic>.from(legs.map((x) => x.toMap())),
        "weight_name": weightName,
        "weight": weight,
        "duration": duration,
        "distance": distance,
    };
}

class Leg {
    final List<Step> steps;
    final String summary;
    final double weight;
    final double duration;
    final double distance;

    Leg({
        required this.steps,
        required this.summary,
        required this.weight,
        required this.duration,
        required this.distance,
    });

    factory Leg.fromJson(String str) => Leg.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Leg.fromMap(Map<String, dynamic> json) => Leg(
        steps: List<Step>.from(json["steps"].map((x) => Step.fromMap(x))),
        summary: json["summary"],
        weight: json["weight"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
        distance: json["distance"],
    );

    Map<String, dynamic> toMap() => {
        "steps": List<dynamic>.from(steps.map((x) => x.toMap())),
        "summary": summary,
        "weight": weight,
        "duration": duration,
        "distance": distance,
    };
}

class Step {
    final String geometry;
    final Maneuver maneuver;
    final Mode mode;
    final DrivingSide drivingSide;
    final String name;
    final List<Intersection> intersections;
    final double weight;
    final double duration;
    final double distance;
    final String? ref;

    Step({
        required this.geometry,
        required this.maneuver,
        required this.mode,
        required this.drivingSide,
        required this.name,
        required this.intersections,
        required this.weight,
        required this.duration,
        required this.distance,
        this.ref,
    });

    factory Step.fromJson(String str) => Step.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Step.fromMap(Map<String, dynamic> json) => Step(
        geometry: json["geometry"],
        maneuver: Maneuver.fromMap(json["maneuver"]),
        mode: modeValues.map[json["mode"]]!,
        drivingSide: drivingSideValues.map[json["driving_side"]]!,
        name: json["name"],
        intersections: List<Intersection>.from(json["intersections"].map((x) => Intersection.fromMap(x))),
        weight: json["weight"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
        distance: json["distance"]?.toDouble(),
        ref: json["ref"],
    );

    Map<String, dynamic> toMap() => {
        "geometry": geometry,
        "maneuver": maneuver.toMap(),
        "mode": modeValues.reverse[mode],
        "driving_side": drivingSideValues.reverse[drivingSide],
        "name": name,
        "intersections": List<dynamic>.from(intersections.map((x) => x.toMap())),
        "weight": weight,
        "duration": duration,
        "distance": distance,
        "ref": ref,
    };
}

enum DrivingSide {
    RIGHT
}

final drivingSideValues = EnumValues({
    "right": DrivingSide.RIGHT
});

class Intersection {
    final int? out;
    final List<bool> entry;
    final List<int> bearings;
    final List<double> location;
    final int? intersectionIn;

    Intersection({
        this.out,
        required this.entry,
        required this.bearings,
        required this.location,
        this.intersectionIn,
    });

    factory Intersection.fromJson(String str) => Intersection.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Intersection.fromMap(Map<String, dynamic> json) => Intersection(
        out: json["out"],
        entry: List<bool>.from(json["entry"].map((x) => x)),
        bearings: List<int>.from(json["bearings"].map((x) => x)),
        location: List<double>.from(json["location"].map((x) => x?.toDouble())),
        intersectionIn: json["in"],
    );

    Map<String, dynamic> toMap() => {
        "out": out,
        "entry": List<dynamic>.from(entry.map((x) => x)),
        "bearings": List<dynamic>.from(bearings.map((x) => x)),
        "location": List<dynamic>.from(location.map((x) => x)),
        "in": intersectionIn,
    };
}

class Maneuver {
    final int bearingAfter;
    final int bearingBefore;
    final List<double> location;
    final String? modifier;
    final String type;
    final String instruction;

    Maneuver({
        required this.bearingAfter,
        required this.bearingBefore,
        required this.location,
        this.modifier,
        required this.type,
        required this.instruction,
    });

    factory Maneuver.fromJson(String str) => Maneuver.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Maneuver.fromMap(Map<String, dynamic> json) => Maneuver(
        bearingAfter: json["bearing_after"],
        bearingBefore: json["bearing_before"],
        location: List<double>.from(json["location"].map((x) => x?.toDouble())),
        modifier: json["modifier"],
        type: json["type"],
        instruction: json["instruction"],
    );

    Map<String, dynamic> toMap() => {
        "bearing_after": bearingAfter,
        "bearing_before": bearingBefore,
        "location": List<dynamic>.from(location.map((x) => x)),
        "modifier": modifier,
        "type": type,
        "instruction": instruction,
    };
}

enum Mode {
    CYCLING,
    PUSHING_BIKE
}

final modeValues = EnumValues({
    "cycling": Mode.CYCLING,
    "pushing bike": Mode.PUSHING_BIKE
});

class Waypoint {
    final double distance;
    final String name;
    final List<double> location;

    Waypoint({
        required this.distance,
        required this.name,
        required this.location,
    });

    factory Waypoint.fromJson(String str) => Waypoint.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Waypoint.fromMap(Map<String, dynamic> json) => Waypoint(
        distance: json["distance"]?.toDouble(),
        name: json["name"],
        location: List<double>.from(json["location"].map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toMap() => {
        "distance": distance,
        "name": name,
        "location": List<dynamic>.from(location.map((x) => x)),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
