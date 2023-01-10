.DEFAULT_GOAL := help

PORT := 8080

help: ## Prints help message.
	@ grep -h -E '^[a-zA-Z0-9_-].+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[1m%-30s\033[0m %s\n", $$1, $$2}'

build:
	@ docker build -t ws . > /dev/null 2>&1

start: build ## Start the server.
	@ echo "Starting the app"
	@ docker run -d -p $(PORT):$(PORT) -e PORT=$(PORT) --name ws-demo -t ws > /dev/null 2>&1
	@ echo "Access the app on http://localhost:$(PORT)/"

stop: ## Stops the server and deletes the container.
	@ echo "Shutdown"
	@ docker rm -f ws-demo > /dev/null 2>&1
	@ docker rmi -f ws > /dev/null 2>&1
	@ echo "Done"
