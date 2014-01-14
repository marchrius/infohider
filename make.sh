function make_version_file()
{
    VERSION="$(cat control | grep 'Version: ' | awk -F' ' '{ print $2 }')"
    echo $VERSION
    BUILD="$(cat .theos/packages/com.marchrius.infohider-$VERSION)"

    let BUILD++

    echo "#define VERSION @\"$VERSION\"" > version.h
    echo "#define BUILD @\"$BUILD\"" >> version.h
    echo "#define LONG_VERSION @\"$VERSION-$BUILD\"" >> version.h
}

make clean

cd infohidersettings

make clean

cd ..

OPS=""
if [ "$1" = "package" ]; then

    OPS=" package "
    make_version_file
else
    if [ "$1" = "install" ]; then

        OPS=" package install "
        make_version_file
    fi
fi

cp Tweak.mm Tweak.xm
make $OPS
rm Tweak.xm


