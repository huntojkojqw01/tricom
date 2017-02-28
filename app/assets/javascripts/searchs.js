$(function() {
  var search = queryParameters().search

  if(search!='' && search != undefined)
    $("#search_field").val(search);
});
function queryParameters () {
        var result = {};

        var uri_dec = decodeURIComponent(window.location.search);
        var params = uri_dec.split(/\?|\&/);

        params.forEach( function(it) {
            if (it) {
                var param = it.split("=");
                result[param[0]] = param[1];
            }
        });
        return result;
    }