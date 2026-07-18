{
  pkgs,
  inputs,
  ...
}:
let
  inherit (pkgs) system;
  pkgsLib = pkgs.lib;
  namespace = "cattery";
  src = ../../.;
  inherit (builtins) readDir;

  findAllNixFiles =
    dir:
    let
      entries = readDir dir;
      subdirs = pkgsLib.filterAttrs (_: type: type == "directory") entries;
      files = pkgsLib.filterAttrs (n: type: type == "regular" && pkgsLib.hasSuffix ".nix" n) entries;
      nested = pkgsLib.concatLists (
        pkgsLib.mapAttrsToList (name: _: findAllNixFiles (dir + "/${name}")) subdirs
      );
    in
    (pkgsLib.mapAttrsToList (name: _: dir + "/${name}") files) ++ nested;

  moduleArgs = {
    inherit
      pkgs
      inputs
      system
      namespace
      ;
    lib = pkgsLib;
    config = { };
    options = { };
    modulesPath = pkgs.path + "/nixos/modules";
    purr = {
      name = "test";
      host = "test";
      user = "tester";
      format = "unknown";
    };
  };

  checkFile =
    path:
    let
      importResult = builtins.tryEval (import path);
      callResult =
        if importResult.success then
          builtins.tryEval (importResult.value moduleArgs)
        else
          {
            success = false;
            value = "import failed";
          };
    in
    {
      path = toString path;
      importOk = importResult.success;
      callOk = callResult.success;
    };

  dirs = [
    "modules/nixos"
    "modules/shared"
    "modules/home"
    "modules/darwin"
  ];

  allResults = pkgsLib.concatLists (
    map (dir: map checkFile (findAllNixFiles (src + "/${dir}"))) dirs
  );

  total = builtins.length allResults;
  importFails = builtins.filter (r: !r.importOk) allResults;
  importFailPaths = builtins.toJSON (map (r: r.path) importFails);
  importAllOk = importFails == [ ];

  callFails = builtins.filter (r: r.importOk && !r.callOk) allResults;
  callFailPaths = builtins.toJSON (map (r: r.path) callFails);
in
pkgs.runCommand "check-module-eval"
  {
    passImport = if importAllOk then "1" else "0";
    inherit importFailPaths callFailPaths total;
  }
  ''
    echo "Module evaluation report:" > $out
    echo "  Total modules: $total" >> $out
    echo "  Import failures: ${toString (builtins.length importFails)}" >> $out
    echo "  Call failures: ${toString (builtins.length callFails)}" >> $out

    if [ "$passImport" != "1" ]; then
      echo "" >> $out
      echo "IMPORT FAILURES:" >> $out
      echo "$importFailPaths" | ${pkgs.jq}/bin/jq -r '.[]' >> $out
      echo "" >&2
      echo "Module import failures:" >&2
      echo "$importFailPaths" | ${pkgs.jq}/bin/jq -r '.[]' >&2
      exit 1
    fi
  ''
