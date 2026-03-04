{
  description = "A Collection of Personal Nix Flake Templates";

  outputs =
    { self, ... }:
    {
      templates = {
        uv2nix = {
          path = ./python/uv2nix.nix;
          description = "A uv2nix project";
        };

        defaultTemplate = self.templates.uv2nix;
      };
    };
}
