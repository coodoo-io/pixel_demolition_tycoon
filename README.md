# Pixel Demolition Tycoon

A `coodoo style` Flutter project.

## Getting started

```sh
# Clean & Install dependencies
make clean

# Run the app
make run (dev-mode)
make run-prod (prod-mode)

# In der Entwicklung Dart files generieren
make build-runner-watch
```

## Commit

Check your code:

```sh
make format
make lint
make test
```

## Build and Release

```sh
# Clean build
make clean
make build-runner

# Build .apk
make build-apk # Google Testing

# Build .appbundle
make build-appbundle # Google Play-Store

# Build .ipa
make build-ipa # Apple iOS
```