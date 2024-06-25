{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
, gnome-themes-extra
, gtk-engine-murrine
, jdupes
, sassc
, themeVariants ? [ ]
, # default: blue
  colorVariants ? [ ]
, # default: all
  sizeVariants ? [ ]
, # default: standard
  tweaks ? [ "round" "blur" "noborder" ]
,
}:

let
  pname = "fluent-gtk-theme";
in
lib.checkListOfEnum "${pname}: theme variants"
  [
    "default"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "teal"
    "grey"
    "all"
  ]
  themeVariants
  lib.checkListOfEnum
  "${pname}: color variants"
  [
    "standard"
    "light"
    "dark"
  ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: size variants"
  [
    "standard"
    "compact"
  ]
  sizeVariants
  lib.checkListOfEnum
  "${pname}: tweaks"
  [
    "solid"
    "float"
    "round"
    "blur"
    "noborder"
    "square"
  ]
  tweaks

  stdenvNoCC.mkDerivation
  (finalAttrs: {
    inherit pname;
    version = "d0731c2bcee6a40b6c1d41b16dfd60f490749a9e";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "fluent-gtk-theme";
      rev = finalAttrs.version;
      hash = "sha256-kSdORVzXMOlwtWYR35Z0OiY3bVBMxn9RTEErimqmpc0=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    buildInputs = [ gnome-themes-extra ];

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      name= HOME="$TMPDIR" ./install.sh \
        ${lib.optionalString (themeVariants != [ ]) "--theme " + builtins.toString themeVariants} \
        ${lib.optionalString (colorVariants != [ ]) "--color " + builtins.toString colorVariants} \
        ${lib.optionalString (sizeVariants != [ ]) "--size " + builtins.toString sizeVariants} \
        ${lib.optionalString (tweaks != [ ]) "--tweaks " + builtins.toString tweaks} \
        --icon nixos \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = {
      description = "Fluent design gtk theme";
      changelog = "https://github.com/vinceliuice/Fluent-gtk-theme/releases/tag/${finalAttrs.version}";
      homepage = "https://github.com/vinceliuice/Fluent-gtk-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [
        luftmensch-luftmensch
        romildo
      ];
    };
  })
