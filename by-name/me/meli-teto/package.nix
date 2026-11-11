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
  version = "0-unstable-2026-11-10";
  src = fetchgit {
    url = "https://git.meli-email.org/meli/meli.git";
    rev = "800001954e85fc326b9a0f9660eca2219272b681";
    hash = "sha256-65IbyPb6cFnQmHBDEtVszki+QlGcUUKKsNyfcuy44cE=";
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
    hash = "sha256-P5y3+JAz+fF80n68Aal/bFzn+SxxRPqB+VctciOSocQ=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "-F"
      "--version=branch=master"
    ];
  };
})
