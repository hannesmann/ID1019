#!/bin/bash
# Run with ./run-project.sh [project]

set -e
set -o pipefail

bold="$(tput bold)"
normal="$(tput sgr0)"

elixir_args=""

echo "${bold}Available:${normal}"

echo "  ${bold}LaTeX:${normal}"
echo "    build_pdflatex [name]"
function build_pdflatex {
  mkdir -p output/tmp
  pdflatex -halt-on-error -shell-escape -output-directory output/tmp "latex/$1/report.tex"
  mv output/tmp/report.pdf "output/$1.pdf"
  rm -Rf output/tmp
}

echo "    all_pdflatex"
function all_pdflatex {
  rm -Rf output
  mkdir -p output

  for d in latex/*/; do echo "${bold}$(basename $d).pdf${normal}" && build_pdflatex "$(basename $d)"; done
}

echo "    build_tectonic [name]"
function build_tectonic {
  mkdir -p output/tmp
  tectonic -Z shell-escape --outfmt pdf --outdir output/tmp "latex/$1/report.tex"
  mv output/tmp/report.pdf "output/$1.pdf"
  rm -Rf output/tmp
}

echo "    all_tectonic"
function all_tectonic {
  rm -Rf output
  mkdir -p output

  for d in latex/*/; do echo "${bold}$(basename $d).pdf${normal}" && build_tectonic "$(basename $d)"; done
}

echo ""
echo "  ${bold}Elixir:${normal}"

echo "    derivative (Derivative calculator)"
function derivative {
  cd src/derivative
  time nice -n -5 elixir main.exs $elixir_args $1 $2 $3 $4 $5
}

echo "    environment (List and tree map)"
function environment {
  cd src/environment
  time nice -n -5 elixir main.exs $elixir_args $1 $2 $3 $4 $5
}

echo "    math (Math evaluator)"
function math {
  cd src/math
  time nice -n -5 elixir main.exs $elixir_args $1 $2 $3 $4 $5
}

echo "    hanoi (Recursive Towers of Hanoi)"
function hanoi {
  cd src/hanoi
  time nice -n -5 elixir main.exs $elixir_args $1 $2 $3 $4 $5
}

echo "    hof (Higher-order functions)"
function hof {
  cd src/hof
  time nice -n -5 elixir main.exs $elixir_args $1 $2 $3 $4 $5
}

# https://unix.stackexchange.com/questions/217292/execute-only-if-it-is-a-bash-function
if [[ $(type -t "$1") == "function" ]]; then
    echo ""
    echo "${bold}Running '$1':${normal}"
    $1 $2 $3 $4 $5 $6
elif [[ ! -z "$1" ]]; then
    echo ""
    echo "${bold}'$1' is not a valid option.${normal}"
    echo "${bold}Run with ./run-project.sh [project]${normal}"
fi
