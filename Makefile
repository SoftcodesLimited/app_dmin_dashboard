WEB_DIR = web
BUILD_DIR = build

run:
	cd $(BUILD_DIR)/$(WEB_DIR) && python3.12 -m http.server 8000
