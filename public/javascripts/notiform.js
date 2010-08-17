// hack to get rails' authenticity token passed correctly
$(document).ajaxSend(function(event, request, settings) {
    if (typeof(window.AUTH_TOKEN) == "undefined") return;
    // IE6 fix for http://dev.jquery.com/ticket/3155
    if (settings.type == 'GET' || settings.type == 'get') return;
  
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
  });

$(document).ready(function() {
  $('.remind-link').click(function() {

    var success = function(clickedOn) {
      return function(data) {
        clickedOn.replaceWith(data.html);
      }
    }($(this));

    $.post('/notiform/recipients/remind/',
           { 'id': $(this).attr('data-id') },
           success, 'json');
  });
});
