{
  self,
  stdenv,
  pnpm,
  nodejs,
  breakpointHook,
}:
stdenv.mkDerivation rec {
  pname = "millennium-assets";
  inherit (self) version;

  src = ../assets;
  pnpmDeps = pnpm.fetchDeps {
    inherit src pname;
    inherit (self) version;
    hash = "sha256-/H3Np/FjxEdU/TwqPPJlpNti2vfyNqUQ2CNIvzlSemA=";
    fetcherVersion = 2;
  };
  nativeBuildInputs = [
    breakpointHook
    pnpm.configHook
    nodejs
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
  '';

  installPhase = ''
    mkdir -p $out/share/millennium/assets
    cp -r core $out/share/millennium/assets/core
    cp -r pipx $out/share/millennium/assets/pipx
    cp -r .millennium  $out/share/millennium/assets/.millennium
    cp plugin.json $out/share/millennium/assets
    cp requirements.txt $out/share/millennium/assets
  '';
}
