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

  $('#create_wufoo-form').submit(function() {
    var success = function(submittedForm) {
      return function(data) {
        var wrapper = $(submittedForm).parent().parent();
        $(submittedForm).parent().slideUp('slow', function() {
          wrapper.append("<div class='header'>PREVIEW KINDA NOT REALLY</div>");
          var subhead = wrapper.children().last();
          subhead.slideDown('slow' , function() {
            wrapper.append("<div class='content' style='display:none'></div>");
            var newForm = wrapper.children().last();
            newForm.html(data.html);
            newForm.slideDown('slow');
          });
        });
        return false;
      }
    }(this);

    $.post(this.action, $(this).serialize(), success, 'json');
    return false;
  });

  $('#create_wufoo-submit').click(function() {
    var form = $(this).parents('form');

    form.submit();
    return false;
  });
});
