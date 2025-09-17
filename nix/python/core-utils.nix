{
  self,
  python311Packages,
}:
python311Packages.buildPythonPackage {
  pname = "millennium-core-utils";
  version = self.version;

  src = ../../sdk;

  pyproject = true;
  build-system = [ python311Packages.setuptools ];

  sourceRoot = "sdk/python-packages/core-utils";

  patches = [
    ./paths.patch
  ];
  postUnpack = ''
    cp $src/package.json $sourceRoot/package.json
    cp $src/README.md $sourceRoot/README.md
  '';
}
