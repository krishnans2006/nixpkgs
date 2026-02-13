{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  hatchling,

  # dependencies
  grpcio,
  grpcio-tools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "logic2-automation";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "saleae";
    repo = "logic2-automation";
    rev = "v${version}";
    hash = "sha256-1zNBJbBazegpeNwNN0C6nFxghdidMvORjJtvKVjBPHQ=";
  };

  # The proto files are in ./proto, the pyproject.toml is in ./python
  # And the pyproject.toml tries to find the proto files in $(pwd)/proto
  # So, we just move the proto files into ./python/proto and set sourceRoot
  # Using the sourceRoot option doesn't work, since that changes the source
  # root *before* postUnpack is run (i.e., before we can move the proto files)
  postUnpack = ''
    mv $sourceRoot/proto $sourceRoot/python/proto
    sourceRoot=$sourceRoot/python
  '';

  pyproject = true;

  build-system = [
    hatchling
  ];

  dependencies = [
    grpcio
    grpcio-tools
    protobuf
  ];

  pythonImportsCheck = [ "saleae.automation" ];

  meta = {
    description = "Automation interface for Saleae Logic 2 software";
    homepage = "https://github.com/saleae/logic2-automation";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.krishnans2006 ];
  };
}
