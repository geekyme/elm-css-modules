import Elm from './Main';

const req = require.context('./', true, /\.css$/);

const app = Elm.Main.embed(document.getElementById('main'));

app.ports.fetchClasses.subscribe(function(cssFile) {
  const styles = req(cssFile);

  setImmediate(function() {
    // We need to defer to next tick otherwise Elm does not process these commands on initial load
    app.ports.receiveClasses.send(styles);
  });
});

// You may handle the other port interactions if you like
// They dynamically add content to various sections

// app.ports.authenticated
// app.ports.logout
// app.ports.login
// app.ports.articles
// app.ports.users
