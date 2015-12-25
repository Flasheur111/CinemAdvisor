start: install
	if [ -d "data_store" ]; then echo "Dir data_store alreadyexists"; else mkdir data_store; echo "Data_store directory created"; fi
	mongod --dbpath data_store&
	npm start

stop:
	killall mongod

install: init
	npm install

clean : stop
	rm -rf npm-debug.log
	rm -rf data_store

init:
	mongod --dbpath data_store&
	killall mongod

.PHONY: stop
