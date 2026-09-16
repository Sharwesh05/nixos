{
  lib,
  stdenv,
  kernel,
  linux-omen-module,
}:

stdenv.mkDerivation {
  pname = "hpomen";
  version = "1.0";

  src = "${linux-omen-module}/hpomen-1.0";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra

    cp hpomen.ko \
      $out/lib/modules/${kernel.modDirVersion}/extra/
  '';

  meta = {
    description = "HP OMEN kernel module";
    homepage = "https://github.com/Sharwesh05/linux-omen-module";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}