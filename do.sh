#! /bin/bash

function require_root() {
	if [ $(id -u) -eq 0 ]; then
		return 0
	else
		echo "Please run me as root."
		exit 1
	fi
}

function is_running() {
	id=$(docker ps -f name=spotifyd -f status=running --format "{{.ID}}")
	if [[ $id ]]; then 
		return 0
	else
		return 1
	fi
}

function container_exists() {
	id=$(docker container ls -a -f name=spotifyd --format "{{.ID}}")
	if [[ $id ]]; then
		return 0
	else
		return 1
	fi
}

function image_exists() {
	id=$(docker images spotifyd --format "{{.ID}}")
	if [[ $id ]]; then
		return 0
	else
		return 1
	fi
}

function do_run() {
	require_root
	if is_running; then
		echo "Container running already, doing nothing."
		return 0
	fi
	
	if container_exists; then
		echo "Starting existing container.."
		docker start spotifyd
		return $?
	fi

	echo "Starting new container."
	docker run --name spotifyd -d -v "/opt/spotifyd/etc/spotifyd.conf:/etc/spotifyd.conf:ro" --rm --device /dev/snd spotifyd
	return $?
}

function do_update() {
	require_root
	is_running && systemctl stop spotifyd
	is_running && docker stop spotifyd
	container_exists && docker rm spotifyd

	if image_exists; then docker rmi spotifyd; fi
	if image_exists; then
		echo "Failed to rm existing image, please fix and re-run."
		return 1
	fi

	docker build -t spotifyd --no-cache .
	if image_exists; then
		echo "Image updated successfully."
	else 
		echo "Failed to build image."
		return 1
	fi
}

function do_build() {
	require_root
	if image_exists; then
		echo "Image exists already. Run $0 update if you want to update the existing build."
		return 0
	fi
	docker build -t spotifyd .
	return $?
}

function usage() {
	echo "$0 [COMMAND]"
	echo
	echo "Commands:"
	echo "		build 	: build the Docker image"
	echo "		run	: run a container named spotifyd using the image"
	echo "		update	: clean existing containers and update existing image with latest binaries"
}


if [ "$1" == "run" ]; then do_run; exit $?;
elif [ "$1" == "build" ]; then do_build; exit $?;
elif [ "$1" == "update" ]; then do_update; exit $?;
else usage
fi

exit 0