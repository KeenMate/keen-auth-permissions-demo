export function redirectHome(time) {
  setTimeout(() => {
    window.location = "/";
  }, time);
}
export function redirect(url, time) {
  setTimeout(() => {
    window.location = url;
  }, time);
}

//https://stackoverflow.com/questions/2090551/parse-query-string-in-javascript
export function getQueryVariable(variable) {
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i = 0; i < vars.length; i++) {
    var pair = vars[i].split("=");
    if (decodeURIComponent(pair[0]) == variable) {
      return decodeURIComponent(pair[1]);
    }
  }
  console.log("Query variable %s not found", variable);
}
