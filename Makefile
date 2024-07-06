IMAGE_NAME := aseprite-container
PODMAN_EXISTS := $(shell command -v podman 2> /dev/null)

# Define colors (ANSI escape codes)
COLOR_RESET = \033[0m
COLOR_GREEN = \033[0;32m  # Green color
COLOR_RED = \033[0;31m    # Red color
COLOR_CYAN = \033[0;36m   # Cyan color
COLOR_YELLOW = \033[1;33m  # Yellow color

all: check-podman start-podman build run

check-podman:
	@if [ ! "$(PODMAN_EXISTS)" ]; then \
		echo -e "${COLOR_RED}Podman is not installed. Please refer to https://podman.io/docs/installation for more installation guidance.${COLOR_RESET}"; \
		exit 1; \
	else \
        echo -e "${COLOR_GREEN}Podman is installed.${COLOR_RESET}"; \
    fi

start-podman:
	@if [ -z "$$(podman info --format '{{.Version}}')" ]; then \
        echo -e "${COLOR_GREEN}Starting Podman...${COLOR_RESET}"; \
        retries=3; \
        while [ $$retries -gt 0 ]; do \
            podman system service -t 0 & \
            sleep 5; \
            if [ -n "$$(podman info --format '{{.Version}}')" ]; then \
                echo -e "${COLOR_GREEN}Podman is now running.${COLOR_RESET}"; \
                break; \
            fi; \
            retries=$$((retries - 1)); \
            echo -e "${COLOR_YELLOW}Retrying... (Attempts left: $$retries)${COLOR_RESET}"; \
        done; \
        if [ $$retries -eq 0 ]; then \
            echo -e "${COLOR_RED}Unable to start Podman after retries.${COLOR_RESET}"; \
            exit 1; \
        fi; \
    else \
        echo -e "${COLOR_GREEN}Podman is already running.${COLOR_RESET}"; \
    fi

build:
	@if ! podman inspect ${IMAGE_NAME} &> /dev/null; then \
        echo -e "${COLOR_CYAN}Building ${IMAGE_NAME}...${COLOR_RESET}"; \
        podman build -t ${IMAGE_NAME} .; \
        echo -e "${COLOR_CYAN}Build ${IMAGE_NAME} complete.${COLOR_RESET}"; \
    else \
        echo -e "${COLOR_GREEN}${IMAGE_NAME} already exists.${COLOR_RESET}"; \
    fi

run:
	@if podman inspect ${IMAGE_NAME} &> /dev/null; then \
        echo -e "${COLOR_YELLOW}Creating output and dependencies directories.${COLOR_RESET}"; \
        if [ ! -d "${PWD}/output" ]; then \
            mkdir -p ${PWD}/output; \
        fi; \
        if [ ! -d "${PWD}/dependencies" ]; then \
            mkdir -p ${PWD}/dependencies; \
        fi; \
        echo -e "${COLOR_CYAN}Running ${IMAGE_NAME} image.${COLOR_RESET}"; \
        podman run --rm\
            -v ${PWD}/output:/output \
            -v ${PWD}/dependencies:/dependencies \
            localhost/aseprite-container; \
        echo -e "${COLOR_GREEN}Build complete. Please check the output folder.${COLOR_RESET}"; \
    else \
        echo -e "${COLOR_RED}${IMAGE_NAME} is not built yet. Please run 'make build' first.${COLOR_RESET}"; \
    fi

.PHONY: all check-podman start-podman build run
