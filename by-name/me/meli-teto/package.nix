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
    rev = "464e9eb9f85bd39d65b5f305f55c862e31da2d5f";
    hash = "sha256-hMEJFJ+zuoN9TduaynTLtZ/J3udIT3v6DVBVpZ6mx0k=";
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
    hash = "sha256-DsOehafFCfnGzg/c5e6MiPzwrIoKRRhSafk5hyXtcI0=";
  };

  passthru.updateScript = [
    "nix-update"
    "-F"
    "--version=branch=master"
  ];

})
