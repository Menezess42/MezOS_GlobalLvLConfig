{
  description = "My favorite nixoS flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix/cf8b6e2d4e8aca8ef14b839a906ab5eb98b08561";
  };
  outputs = {self, nixpkgs, ...}@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs{
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
      {
        nixosConfigurations = {
          nixos = nixpkgs.lib.nixosSystem{
            specialArgs = {inherit system; inherit inputs; };
            modules = [
              ./configuration.nix
	      inputs.stylix.nixosModules.stylix
            ];
          };
        };
      };
}
