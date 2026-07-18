{ lib, ... }:
let
  inherit (lib)
    splitString
    sublist
    concatStringsSep
    removePrefix
    removeSuffix
    hasPrefix
    stringToCharacters
    replaceStrings
    ;

  inherit (lib.strings) escapeC normalizePath;
in
{
  findNixPaths =
    dir:
    builtins.map (f: (dir + "/${f}")) (
      builtins.filter (file: builtins.match ".+\\.nix" file != null) (
        builtins.attrNames (builtins.readDir dir)
      )
    );

  getRootDomain =
    domain:
    let
      names = splitString "." domain;
      length = builtins.length names;
      root = sublist (length - 2) (length - 1) names;
    in
    concatStringsSep "." root;

  # see: https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/utils.nix
  # Escape a path according to the systemd rules. FIXME: slow
  # The rules are described in systemd.unit(5) as follows:
  # The escaping algorithm operates as follows: given a string, any "/" character is replaced by "-", and all other characters which are not ASCII alphanumerics, ":", "_" or "." are replaced by C-style "\x2d" escapes. In addition, "." is replaced with such a C-style escape when it would appear as the first character in the escaped string.
  # When the input qualifies as absolute file system path, this algorithm is extended slightly: the path to the root directory "/" is encoded as single dash "-". In addition, any leading, trailing or duplicate "/" characters are removed from the string before transformation. Example: /foo//bar/baz/ becomes "foo-bar-baz".
  escapeSystemdPath =
    s:
    let
      replacePrefix =
        p: r: s:
        (if (hasPrefix p s) then r + (removePrefix p s) else s);
      trim = s: removeSuffix "/" (removePrefix "/" s);
      normalizedPath = normalizePath s;
    in
    replaceStrings [ "/" ] [ "-" ] (
      replacePrefix "." (escapeC [ "." ] ".") (
        escapeC (stringToCharacters " !\"#$%&'()*+,;<=>=@[\\]^`{|}~-") (
          if normalizedPath == "/" then normalizedPath else trim normalizedPath
        )
      )
    );
}
