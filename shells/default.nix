{ pkgs }:
pkgs.mkShell {
  packages = [ pkgs.curl ];
}
