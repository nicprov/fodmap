var app = Elm.Main.init()

app.ports.setBodyClass.subscribe(function(className) {
    document.body.className = className;
});