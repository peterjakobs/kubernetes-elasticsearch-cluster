#!/bin/bash
#
# To update image versions and the Kubernetes manifests edit:
# - ./build_images.sh - #Versions section
# - ./debian-oraclejava/Dockerfile - Versions and download path
# - ./docker-elasticsearch/Dockerfile - FROM and ES_VERSION lines
# - ./docker-elasticsearch-kubernetes/Dockerfile - FROM line
# - ./docker-elasticsearch-curator/Dockerfile - "pip install" line
# - ./docker-kibana/Dockerfile - KIBANA_VERSION line
# - ./fluentd-elasticsearch/Gemfile - Gem versions
# - ./elasticsearch-cerebro/Dockerfile - ENV CEREBRO_VERSION line
# - Manifest es-curator_v1beta1.yaml - "image" line
# - Manifest es-data-statefulset.yaml - "image" line
# - Manifest es-master.yaml - "image" line
# - Manifest fluentd-es-ds.yaml - "image" line
# - Manifest kibana.yaml - "image" line
# - Manifest cerebro.yaml - "image" line

# Versions
JAVA_VERSION=8-172
ES_VERSION=6.2.3
CURATOR_VERSION=5.5.1
FLUENTD_VERSION=1.2.0
CEREBRO_VERSION=0.7.3

REGISTRY=carlosedp

# Architectures
ARCHITECTURES=(arm64)

# Images and respective versions
IMAGES=(debian-oraclejava docker-elasticsearch docker-elasticsearch-kubernetes docker-elasticsearch-curator fluentd-elasticsearch docker-kibana elasticsearch-cerebro)
VERSIONS=($JAVA_VERSION $ES_VERSION $ES_VERSION $CURATOR_VERSION $FLUENTD_VERSION $ES_VERSION $CEREBRO_VERSION)

num_img=$((${#IMAGES[*]}-1))

function build_image {
    I=$1
    ARCH_LIST=''
    for ARCH in $ARCHITECTURES; do
        ARCH_LIST="linux/$ARCH $ARCH_LIST"
        IMAGE=${IMAGES[$I]}
        VERSION=${VERSIONS[$I]}

        echo "Building image $IMAGE version $VERSION"
        docker build -t $REGISTRY/$IMAGE:$VERSION-$ARCH ./$IMAGE
        echo "Pushing image $REGISTRY/$IMAGE:$VERSION-$ARCH"
        docker push $REGISTRY/$IMAGE:$VERSION-$ARCH
    done

    # Generate the manifests for the images
    echo "Generating manifests for image $IMAGE"
    manifest-tool push from-args --platforms $ARCH_LIST --template "$REGISTRY/$IMAGE:$VERSION-ARCH" --target "$REGISTRY/$IMAGE:latest"
    manifest-tool push from-args --platforms $ARCH_LIST --template "$REGISTRY/$IMAGE:$VERSION-ARCH" --target "$REGISTRY/$IMAGE:$VERSION"

    echo ""
}

if [[ $# -eq 0 ]]; then
    echo "Choose a image to build or 'all' to build all images"
    echo "Image list: " ${IMAGES[*]}
    exit 0
fi

if [[ "$1" == "all" ]]; then
    for I in $(seq 0 $num_img); do
        build_image $I
    done
else
    INDEX=`echo ${IMAGES[@]/$1//} | cut -d/ -f1 | wc -w | tr -d ' '`
    build_image $INDEX
fi
