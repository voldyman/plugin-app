FILES = Main.vala

all: buildApp buildPlugin

buildApp:
	valac --pkg libpeas-1.0 --vapi=app.vapi --header=app.h $(FILES) -o test_app

buildPlugin:
	valac --pkg libpeas-1.0 --library=really -X -shared -X -fPIC plug.vala app.vapi -o libreally.so

clean:
	rm -rf *.vapi *.h *.so test_app
