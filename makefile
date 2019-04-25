NAME := redshl

build: run
	@docker build -t ${NAME} .

run:
	@docker run -it ${NAME} bash