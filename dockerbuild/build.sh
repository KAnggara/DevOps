#!/bin/bash
set -euo pipefail

SHORT_SHA=$(echo "${SHA}" | head -c 7)

abort() {
  echo "❌ $*" >&2
  exit 1
}

login() {
  echo "🔐 Login ke registry: ${REGISTRY}"
  echo "${PASSWORD}" | docker login -u "${USERNAME}" --password-stdin "${REGISTRY}" || abort "Gagal login!"
}

docker_build() {
  echo "📦 Building image..."

  cd "${WORK_DIR}" || abort "Workdir tidak ditemukan: ${WORK_DIR}"
  pwd

  IMAGE_NAME=$(echo "${IMAGE_NAME}" | tr '[:upper:]' '[:lower:]')

  DATE=$(TZ=Asia/Jakarta date +"%Y%m%d-%H%M")

  # Validasi Dockerfile
  if [[ ! -f "${DOCKERFILE}" ]]; then
    abort "Dockerfile tidak ditemukan di path: ${DOCKERFILE}"
  fi

  case "${BRANCH}" in
    main|master)
      if [[ "${TAG_STRATEGY:-date}" == "run_number" && -n "${RUN_NUMBER:-}" ]]; then
        TAG1="release-${RUN_NUMBER}"
      else
        TAG1="release-${DATE}"
      fi
      ;;
    feature-*)
      TAG1="sit-${SHORT_SHA}"
      ;;
    *)
      TAG1="dev-${SHORT_SHA}"
      ;;
  esac

  echo "🔖 Tag yang digunakan: ${TAG1}, latest"
  docker build -f "${DOCKERFILE}" -t "${REGISTRY}/${IMAGE_NAME}:${TAG1}" -t "${REGISTRY}/${IMAGE_NAME}:latest" .

  echo "🚀 Push image ke ${REGISTRY}"
  docker push --all-tags "${REGISTRY}/${IMAGE_NAME}"
}

main() {
  login
  docker_build
}

main "$@"
