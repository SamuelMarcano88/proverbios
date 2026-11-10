#!/usr/bin/env bash
set -euo pipefail

flutter_version="${FLUTTER_VERSION:-3.41.1}"

if command -v flutter >/dev/null 2>&1; then
  flutter pub get
  flutter build web --release
  exit 0
fi

cache_dir="${NETLIFY_CACHE_DIR:-${HOME}/.cache}"
flutter_dir="${cache_dir}/flutter-${flutter_version}"

if [ ! -x "${flutter_dir}/bin/flutter" ]; then
  mkdir -p "${flutter_dir}"
  archive="$(mktemp)"
  trap 'rm -f "${archive}"' EXIT
  curl --fail --location --silent --show-error \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${flutter_version}-stable.tar.xz" \
    --output "${archive}"
  tar -xJf "${archive}" --strip-components=1 -C "${flutter_dir}"
fi

"${flutter_dir}/bin/flutter" config --no-analytics
"${flutter_dir}/bin/flutter" pub get
"${flutter_dir}/bin/flutter" build web --release \
  --dart-define="SUPABASE_URL=${SUPABASE_URL:-}" \
  --dart-define="SUPABASE_PUBLISHABLE_KEY=${SUPABASE_PUBLISHABLE_KEY:-}"
