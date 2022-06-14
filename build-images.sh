#!/bin/bash

# Terminate on error
set -e

# Prepare variables for later use
images=()
# The image will be pushed to GitHub container registry
repobase="${REPOBASE:-ghcr.io/nethserver}"
#Get WebTop version
webtop_version=$(cat ${PWD}/webtop5-build/VERSION)

# Reuse existing webtopbuilder container, to speed up builds
if ! buildah containers --format "{{.ContainerName}}" | grep -q webtopbuilder; then
    echo "Pulling maven runtime..."
    buildah from --name webtopbuilder-tmp docker.io/library/maven:3.6-openjdk-8
    buildah run webtopbuilder-tmp  apt-get  update
    buildah run webtopbuilder-tmp  apt-get  install -y  nodejs make
    buildah commit --rm webtopbuilder-tmp webtopbuilder-image
    buildah from --name webtopbuilder \
	    -v "${PWD}/webtop5-build:/webtop5-build:z" \
	    localhost/webtopbuilder-image
fi

if [ ! -e ${PWD}/webtop5-build/webtop-webapp-5.war ]; then
    buildah run webtopbuilder sh -c "mkdir -p ~/.m2"
    buildah run webtopbuilder sh -c "cp webtop5-build/settings.xml  ~/.m2/"
    buildah run webtopbuilder sh -c "cd webtop5-build/ && ./prep-sources"
fi

#Create webtop-webapp container
reponame="webtop-webapp"
container=$(buildah from docker.io/library/tomcat:8-jre8)
buildah add ${container} ${PWD}/webtop5-build/webtop-webapp-5.war /usr/local/tomcat/webapps/webtop.war
# Commit the image
buildah commit --rm "${container}" "${repobase}/${reponame}"

# Append the image URL to the images array
images+=("${repobase}/${reponame}")

# Configure the image name
reponame="webtop"

# Create a new empty container image
container=$(buildah from scratch)

# Reuse existing nodebuilder-webtop container, to speed up builds
if ! buildah containers --format "{{.ContainerName}}" | grep -q nodebuilder-webtop; then
    echo "Pulling NodeJS runtime..."
    buildah from --name nodebuilder-webtop -v "${PWD}:/usr/src:Z" docker.io/library/node:lts
fi

echo "Build static UI files with node..."
buildah run nodebuilder-webtop sh -c "cd /usr/src/ui && yarn install && yarn build"

# Add imageroot directory to the container image
buildah add "${container}" imageroot /imageroot
buildah add "${container}" ui/dist /ui
# Setup the entrypoint, ask to reserve one TCP port with the label and set a rootless container
buildah config --entrypoint=/ \
    --label="org.nethserver.authorizations=traefik@any:routeadm" \
    --label="org.nethserver.tcp-ports-demand=1" \
    --label="org.nethserver.rootfull=0" \
    --label="org.nethserver.images=${repobase}/webtop-webapp:${IMAGETAG:-latest}" \
    "${container}"
# Commit the image
buildah commit "${container}" "${repobase}/${reponame}"

# Append the image URL to the images array
images+=("${repobase}/${reponame}")

#
# NOTICE:
#
# It is possible to build and publish multiple images.
#
# 1. create another buildah container
# 2. add things to it and commit it
# 3. append the image url to the images array
#

#
# Setup CI when pushing to Github. 
# Warning! docker::// protocol expects lowercase letters (,,)
if [[ -n "${CI}" ]]; then
    # Set output value for Github Actions
    printf "::set-output name=images::%s\n" "${images[*],,}"
else
    # Just print info for manual push
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${IMAGETAG:-latest}" ; done
    printf "\n"
fi
