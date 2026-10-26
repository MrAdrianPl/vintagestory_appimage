
set -eux

ARCH="$(uname -m)"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"
EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"
RELEASE="stable"
VERSION="1.22.7"
GAMEURL="https://cdn.vintagestory.at/gamefiles/$RELEASE/vs_client_linux-x64_$VERSION.tar.gz"

export ICON=/vintagestory/assets/gameicon.png
export DESKTOP=/vintagestory/Vintagestory.desktop
export OUTPATH=/dist
export MAIN_BIN=/vintagestory/run.sh
export OUTNAME="vintagestory-anylinux-$ARCH-$VERSION.AppImage"
export DEPLOY_DOTNET=1

pacman -Syu --noconfirm \
	base-devel       \
	curl             \
	git              \
	wget             \
	xorg-server-xvfb \
	dotnet-runtime-10.0 \
	patchelf \
	glibc \
	openal

echo "Bundling Application..."


wget "$GAMEURL"
tar -xf "vs_client_linux-x64_$VERSION.tar.gz"

find vintagestory/assets/ -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
		filename="$(basename -- "$file")"
		ln -sf "$filename" "${file%/*}"/"${filename,,}"
	done

mkdir -p ./AppDir/bin/

cp -r ./vintagestory/* ./AppDir/bin/
cp ./run.sh ./AppDir/bin/run.sh

wget "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh --add-common

echo "Bundling AppImage..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /vintagestory/run.sh

./quick-sharun --make-appimage
