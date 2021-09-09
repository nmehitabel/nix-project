{ externalOverrides ? {}
}:

let

    external = import ./external // externalOverrides;

    buildOverlay = self: super: rec {
        niv = (import external.niv {}).niv;
        nix-project-lib = super.recurseIntoAttrs
                (self.callPackage (import ./lib.nix) {});
        nix-project-exe = self.callPackage (import ./project.nix) {};
    };

    nixpkgs = import external.nixpkgs-stable {
        config = {};
        overlays = [ buildOverlay ];
    };

    distribution = {
        inherit (nixpkgs)
        nix-project-lib
        nix-project-exe;
    };

in {
    inherit
    distribution
    nixpkgs;
}
