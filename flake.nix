{
  description = "A Collection of Personal Nix Flake Templates";

  outputs =
    { self, ... }:
    {
      templates = {
        trivial = {
          path = ./templates/trivial;
          description = "A trivial template that does nothing much.";
        };

        uv2nix = (import ./python/uv2nix);

        defaultTemplate = self.templates.trivial;
      };
    };
}
