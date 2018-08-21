with import <nixpkgs> {};

let pyenv = python36.withPackages (ps: with ps; [
    jupyterlab
    pandas
    numpy
    matplotlib
    ]);

in

stdenv.mkDerivation rec {
  name = "python-env";

  buildInputs = [
    pyenv
    postgresql
    screen
  ];

  shellHook = ''
  # set -x
  set -e
  export PG_DATA="data"
  [ -d data ] || mkdir data
  datafiles=$(ls -A data)
  if [ -z ''${datafiles:0:1} ]; then
     initdb -D data
     createdb $(whoami)
  fi
  pg_ctl -D data -l data/logfile start
  echo ""
  echo "using ${pyenv.name}; ${postgresql.name}"
  echo "default database: $(whoami)"
  '';

}
