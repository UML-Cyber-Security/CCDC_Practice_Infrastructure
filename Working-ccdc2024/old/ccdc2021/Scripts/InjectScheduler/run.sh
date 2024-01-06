function build_container() {
	docker build -t inject_scheduler .
}

function run_container() {
	docker run -t --name scheduler inject_scheduler
}

function remove_container() {
	docker rm -f scheduler || true
	docker rmi inject_scheduler || true
}


remove_container

build_container
execute_container
remove_container
