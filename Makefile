PACKAGE = de.markusfisch.android.libra
APK = app/build/outputs/apk/debug/app-debug.apk

all: debug install start

debug:
	./gradlew assembleDebug

lint:
	./gradlew lintDebug

infer: clean
	infer -- ./gradlew assembleDebug

sonarqube:
	./gradlew sonarqube

release: lint
	@./gradlew \
		assembleRelease \
		-Pandroid.injected.signing.store.file=$(ANDROID_KEYFILE) \
		-Pandroid.injected.signing.store.password=$(ANDROID_STORE_PASSWORD) \
		-Pandroid.injected.signing.key.alias=$(ANDROID_KEY_ALIAS) \
		-Pandroid.injected.signing.key.password=$(ANDROID_KEY_PASSWORD)

install:
	adb $(TARGET) install -r $(APK)

start:
	adb $(TARGET) shell 'am start -n \
		$(PACKAGE).debug/$(PACKAGE).activity.SplashActivity'

uninstall:
	adb $(TARGET) uninstall $(PACKAGE).debug

clean:
	./gradlew clean
