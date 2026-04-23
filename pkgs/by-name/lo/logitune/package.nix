{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "logitune";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "mmaher88";
    repo = "logitune";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eCRuSBC+f9IWGfraqkPQgwG0xxBbQIC2RadLlbEJIpQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    systemd
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/etc/xdg/autostart" "etc/xdg/autostart"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_TESTING=OFF"
    "-DLOGITUNE_VERSION=${finalAttrs.version}"
  ];

  meta = {
    description = "Configure Logitech devices on Linux (Options+ clone)";
    homepage = "https://github.com/mmaher88/logitune";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.garrettgr ];
    platforms = with lib.platforms; linux;
    mainProgram = "logitune";
  };
})
