{ pkgs, lib, config, ... }:
let
  markerType = lib.types.submodule {
    options = {
      location = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      style.label = lib.mkOption {
        type = lib.types.nullOr
          (lib.types.strMatching "[A-Z0-9]");
        default = null;
      };
    };
  };

  userType = lib.types.submodule {
    options = {
      departure = lib.mkOption {
        type = markerType;
        default = {};
      };
    };
  };

in {

  options = {
    users = lib.mkOption {
      type = lib.types.attrsOf userType;
    };
    
    map.markers = lib.mkOption {
      type = lib.types.listOf markerType;
    };
  };

  config = {
    map.markers = lib.filter
      (marker: marker.location != null)
      (lib.concatMap (user: [
        user.departure
      ]) (lib.attrValues config.users));

    map.center = lib.mkIf
      (lib.length config.map.markers >= 1)
      null;

    map.zoom = lib.mkIf
      (lib.length config.map.markers >= 2)
      null;

    requestParams = let
      paramForMarker = marker:
        let
          attributes =
            lib.optional (marker.style.label != null)
            "label:${marker.style.label}"
            ++ [
              "$(${config.scripts.geocode}/bin/geocode ${
                lib.escapeShellArg marker.location
              })"
            ];
          in "markers=\"${lib.concatStringsSep "|" attributes}\"";
      in
        builtins.map paramForMarker config.map.markers;
  };
}
