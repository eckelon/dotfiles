#!/bin/sh
# Builds the dropin bundle that Eclipse installs at startup and copies it into the live install.
#
# Bump Bundle-Version in MANIFEST.MF when the code changes, then:
#   ./scripts/eclipse-dropin/build.sh
#   rm the previous local.expand_*.jar from the dropins dir (two versions of the same bundle
#   both get installed and only one wins)
#
# The jar itself is versioned by chezmoi (dot_eclipse/java-2026-09/.../dropins/) so `chezmoi
# apply` needs no JDK. bundles.info is NOT versioned: p2's dropins reconcile rewrites it on the
# next start from whatever jars are in that directory.
set -e

HERE=$(cd "$(dirname "$0")" && pwd)
ECLIPSE_INSTALL=${ECLIPSE_INSTALL:-$HOME/eclipse/java-2026-09/Eclipse.app/Contents/Eclipse}
JAVA=${JAVA:-/Library/Java/JavaVirtualMachines/temurin-27.jdk/Contents/Home/bin}
VERSION=$(sed -n 's/^Bundle-Version: //p' "$HERE/MANIFEST.MF")
JAR="$HERE/local.expand_$VERSION.jar"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

"$JAVA/javac" --release 21 -nowarn -cp "$HOME/.p2/pool/plugins/*" -d "$TMP" "$HERE/ExpandStartup.java"
"$JAVA/jar" --create --file "$JAR" --manifest "$HERE/MANIFEST.MF" "$HERE/plugin.xml" -C "$TMP" .

mkdir -p "$ECLIPSE_INSTALL/dropins"
rm -f "$ECLIPSE_INSTALL/dropins"/local.expand_*.jar
cp "$JAR" "$ECLIPSE_INSTALL/dropins/"
echo "installed $JAR -> $ECLIPSE_INSTALL/dropins/"
echo "now copy it into the repo: chezmoi add $ECLIPSE_INSTALL/dropins/local.expand_$VERSION.jar"
