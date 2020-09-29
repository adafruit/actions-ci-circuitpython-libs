V=0
while getopts 'abf:v' flag; do
  case "${flag}" in
    v) V=1 ;;
    *) print_usage
       exit 1 ;;
  esac
done

echo '#################### Translate Repo Name For Build Tools filename_prefix ####################'
NAME=$(basename `git rev-parse --show-toplevel`)
NAME=${NAME,,}
NAME=$( echo $NAME | tr '_' '-')
echo $NAME
echo -e '\n\n\n'

echo '#################### Set up Python ##################'
python3 --version
echo -e '\n\n\n'

echo '################## Install dependencies ##################'
if [[ $V == 1 ]]; then
    wget -O - https://raw.githubusercontent.com/dherrada/actions-ci-circuitpython-libs/master/install.sh | sed 's/pip/pip3/g' | bash || exit 1
else
    echo "Installing required tools"
    wget -O - https://raw.githubusercontent.com/dherrada/actions-ci-circuitpython-libs/master/install.sh | sed 's/pip/pip3/g' | bash > /dev/null
fi

echo -e '\n\n\n'

echo '################### Pip install pylint, black, & Sphinx ##################'
if [[ $V == 1 ]]; then
    pip3 install --force-reinstall pylint black==19.10b0 Sphinx sphinx-rtd-theme || exit 1
else
    echo 'Installing pylint, black, & Sphinx'
    pip3 install --force-reinstall pylint black==19.10b0 Sphinx sphinx-rtd-theme > /dev/null
fi
echo -e '\n\n\n'

echo '################## Library version ##################'
git describe --dirty --always --tags
echo -e '\n\n\n'

echo '################## Check formatting ##################'
black --check --target-version=py35 . || exit 1
echo -e '\n\n\n'

echo '################## Pylint ##################'
pylint $( find . -path './adafruit*.py' ) || exit 1
([[ ! -d "examples" ]] || pylint --disable=missing-docstring,invalid-name,bad-whitespace $( find . -path "./examples/*.py" )) || exit 1
echo -e '\n\n\n'

echo '################## Build assets ##################'
circuitpython-build-bundles --filename_prefix $NAME --library_location . || exit 1
echo -e '\n\n\n'

echo '################## Build Docs ####################'
cd docs
sphinx-build -E -W -b html . _build/html
cd ..

rm -rf build-adafruit-circuitpython-*
rm -rf build_deps
