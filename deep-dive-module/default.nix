{ lib, ... }:
{
  options = {
    scripts.output = lib.mkOption {
      type = lib.types.lines;
    };
  };

  config = {
    scripts.output = 42;
  };
}
