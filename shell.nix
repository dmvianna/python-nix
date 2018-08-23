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
  ];
  PGDATA = "data";
  shellHook = ''
  trap "kill 0" EXIT
  
  [ -d data ] || mkdir data
  datafiles=$(ls -A data)
  if [ -z ''${datafiles:0:1} ]; then
     initdb
     wait
     postgres &
     sleep 1
     createdb $(whoami)
  else
     postgres &
  fi
  echo ""
  echo "using ${pyenv.name}; ${postgresql.name}"
  echo "default database: $(whoami)"
  '';

}
