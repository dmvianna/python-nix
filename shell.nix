with import <nixpkgs> {};

let pyenv = python36.withPackages (ps: with ps; [
    jupyterlab
    pandas
    numpy
    matplotlib
    ]);
    defaultDb = "data";
   
in

stdenv.mkDerivation rec {
  name = "python-env";

  buildInputs = [
    pyenv
    postgresql
    screen
  ];

  postInstall = ''
  export PG_DATA ="data"
  mkdir data
  initdb -D data
  pg_ctl -D data -l data/logfile start
  createdb ${defaultDb}
  '';
  shellHook = ''
  echo ""
  echo "using ${pyenv.name}; ${postgresql.name}"
  echo "default database: ${defaultDb}"
  '';

}
