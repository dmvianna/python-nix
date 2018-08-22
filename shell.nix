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

  shellHook = ''
  # set -x
  
  startdb () 
  { 
    pg_ctl -D data -l data/logfile start
  }

  stopdb ()
  {
    pg_ctl -D data stop
  }

  # main
  export PGDATA="data"
  [ -d data ] || mkdir data
  datafiles=$(ls -A data)
  if [ -z ''${datafiles:0:1} ]; then
     initdb -D data
     wait
     startdb
     sleep 1
     createdb $(whoami)
  else
     startdb
  fi
  echo ""
  echo "using ${pyenv.name}; ${postgresql.name}"
  echo "default database: $(whoami)"
  echo "don't forget to stop db (stopdb) before exiting!"
  '';

}
