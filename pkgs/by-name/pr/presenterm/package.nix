{ lib
, fetchFromGitHub
, rustPlatform
, libsixel
, testers
, presenterm
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "presenterm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    rev = "refs/tags/v${version}";
    hash = "sha256-du/fL+6GYFm20jDdPwA/ImFI4HvhNTH2kVgToM0FETY=";
  };

  buildInputs = [
    libsixel
  ];

  cargoHash = "sha256-zX6/1IRZVNjXtaJbQ/eUnGUOFvPTuKBHtVLpkfPr7XA=";

  # Crashes at runtime on darwin with:
  # Library not loaded: .../out/lib/libsixel.1.dylib
  buildFeatures = lib.optionals (!stdenv.isDarwin) [ "sixel" ];

  # Skip test that currently doesn't work
  checkFlags = [ "--skip=execute::test::shell_code_execution" ];

  passthru.tests.version = testers.testVersion {
    package = presenterm;
    command = "presenterm --version";
  };

  meta = with lib; {
    description = "A terminal based slideshow tool";
    changelog = "https://github.com/mfontanini/presenterm/releases/tag/v${version}";
    homepage = "https://github.com/mfontanini/presenterm";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
}
