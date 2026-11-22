{
  capnproto,
  fetchgit,
  meli,
  nettle,
  rustPlatform,
  nix-update-script,
}:
meli.overrideAttrs (old: rec {
  pname = old.pname + "-tetos";
  # Track development commits with: nix-update -F meli-teto --version=branch
  version = "0-unstable-2026-11-22";
  src = fetchgit {
    url = "https://git.meli-email.org/meli/meli.git";
    rev = "edc285da612ecda7911be9a514921aaff534462d";
    hash = "sha256-rDNJUVUZpHZAdcC4S2/bLGC6LvKziZxHOg5lQTSSHOs=";
  };

  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    capnproto
    rustPlatform.bindgenHook
  ];
  buildInputs = (old.buildInputs or [ ]) ++ [ nettle ];

  # meli's cargoDeps was created from the nixpkgs source before overrideAttrs,
  # so changing cargoHash alone does not recreate the vendor derivation.
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-+G839h3hOWr8bASEXk3RPHKQoXOqMfDpzrBjR4UzYPw=";
  };

  passthru.updateScript = [
    "nix-update"
    "-F"
    "--version=branch=master"
  ];

})
