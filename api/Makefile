start: install
	mongod --dbpath data_store&
	npm start

stop:
	killall mongod

install: init
	npm install

clean:
	rm -rf npm-debug.log
	rm -rf data_store/*

init:
	mongod --dbpath data_store&
	killall mongod

.PHONY: stop
