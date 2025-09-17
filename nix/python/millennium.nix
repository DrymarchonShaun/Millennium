{
  self,
  python311Packages,
}:
python311Packages.buildPythonPackage {
  pname = "millennium";
  version = self.version;

  src = ../../sdk;

  pyproject = true;
  build-system = [ python311Packages.setuptools ];

  sourceRoot = "sdk/python-packages/millennium";

  patches = [
    ./paths.patch
  ];
  postUnpack = ''
    cp $src/package.json $sourceRoot/package.json
    cp $src/README.md $sourceRoot/README.md
  '';
}
