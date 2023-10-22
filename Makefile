-include .env

config:
	@echo "Connecting to 1Password..."
	
	@echo "Fetching .env file"
	@rm -rf .env
	# op document get 12345 --output=.env
	op document get ".env" --vault "Florian Schmitz" --output=.env

	@echo "Fetching Firebase files"
	@rm -rf android/app/google-services.json
	op document get "google-services" --vault "Florian Schmitz" --output=android/app/google-services.json
	@rm -rf ios/Runner/GoogleService-Info.plist
	op document get "GoogleService-Info" --vault "Florian Schmitz" --output=ios/Runner/GoogleService-Info.plist
	@rm -rf lib/firebase_options.dart
	op document get "firebase_options" --vault "Florian Schmitz" --output=lib/firebase_options.dart

	${shell eval include .env && export}
	@echo "Done"

run:
	flutter run
run-prod:
	flutter run --release

clean:
	flutter clean
	flutter pub get
	make build-runner
	make format

format:
	dart format . --line-length 120

lint:
	dart analyze

test:
	flutter test
.PHONY:test

build-runner:
	dart run build_runner build --delete-conflicting-outputs

build-runner-watch:
	dart run build_runner watch --delete-conflicting-outputs

appicon:
	dart run flutter_launcher_icons -f flutter_launcher_icons.yaml

splashscreen:
	dart run flutter_native_splash:create --path=flutter_native_splash.yaml

# ANDROID BUILD
build-apk:
	@echo "Building Android .apk ..."
	make clean
	flutter build apk --target-platform=android-arm,android-arm64 --obfuscate --split-debug-info=./dist/debug/
	cp build/app/outputs/bundle/release/app-release.apk dist/
	mv dist/app-release.apk dist/pixel_demolition_tycoon.apk

build-appbundle:
	@echo "Building Android .aab ..."
	make clean
	flutter build appbundle --obfuscate --split-debug-info=./dist/debug/
	cp build/app/outputs/bundle/release/app-release.aab dist/
	mv dist/app-release.aab dist/pixel_demolition_tycoon.aab

# iOS BUILD
build-ipa:
	@echo "Building Apple .ipa ..."
	make clean
	rm -rf ios/dist
	flutter build ipa --obfuscate --split-debug-info=./dist/debug/ --export-options-plist=ios/ios-export-options.plist --suppress-analytics
	cp build/ios/ipa/pixel_demolition_tycoon.ipa dist/pixel_demolition_tycoon.ipa