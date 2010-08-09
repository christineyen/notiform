
 $(document).ajaxSend(function(event, request, settings) {
    if (typeof(window.AUTH_TOKEN) == "undefined") return;
    // IE6 fix for http://dev.jquery.com/ticket/3155
    if (settings.type == 'GET' || settings.type == 'get') return;
  
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
  });

$(document).ready(function() {
  $('.remind-link').click(function() {

    var callback = function(clickedOn) {
      return function(data) {
        clickedOn.hide();
      }
    }($(this));

    $.post('/notiform/recipients/remind/',
           { 'id': $(this).attr('data-id') },
           callback);
  });
});
