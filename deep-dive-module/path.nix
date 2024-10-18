{ lib, config, ... }:
let
  pathType = lib.types.submodule {
    options = {
      locations = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };

      style = lib.mkOption {
        type = pathStyleType;
        default = {};
      };
    };
  };

  pathStyleType = lib.types.submodule {
    options = {
      weight = lib.mkOption {
        type = lib.types.ints.between 1 20;
        default = 5;
      };
    };
  };
  
in
{
  options = {
    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.pathStyle = lib.mkOption {
          type = pathStyleType;
          default = {};
        };
      });
    };
    
    map.paths = lib.mkOption {
      type = lib.types.listOf pathType;
    };
  };
  config = {

    map.paths = builtins.map (user: {
      locations = [
        user.departure.location
        user.arrival.location
      ];
      style = user.pathStyle;
    }) (lib.filter (user:
      user.departure.location != null
      && user.arrival.location != null
    ) (lib.attrValues config.users));
  
    requestParams =
      let
        attrForLocation = loc:
          "$(${config.scripts.geocode}/bin/geocode ${lib.escapeShellArg loc})";
        paramForPath = path:
          let
            attributes =
              [
                "weight:${toString path.style.weight}"
              ]
              ++ builtins.map attrForLocation path.locations;
          in ''path="${lib.concatStringsSep "|" attributes}"'';
      in builtins.map paramForPath config.map.paths;
  };
}
