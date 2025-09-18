{
  breakpointHook,
  self,
  stdenv,
  nodejs,
  pnpm,
  faketty,
}:
stdenv.mkDerivation rec {
  pname = "millennium-sdk-fml";
  # inherit (self) version;
  version = "fml";

  src = ../../sdk;
  pnpmDeps = pnpm.fetchDeps {
    inherit (self) version;
    inherit src pname;
    #TODO: automatic hash update
    hash = "sha256-Je0nigOKUklS+7iE1R0vwIMe+cDeOZccIXQ7nLeD9Ao=";
    fetcherVersion = 2;
  };

  nativeBuildInputs = [
  breakpointHook
    pnpm.configHook
    nodejs
    faketty
  ];

  buildPhase = ''
    runHook preBuild
    faketty pnpm run build
  '';

  installPhase = ''
    mkdir -p $out/share/millennium/shims
    cp -r typescript-packages/loader/build/* $out/share/millennium/shims
  '';
}
