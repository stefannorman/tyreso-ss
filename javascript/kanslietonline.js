$(document).ready(function() {
  
  $('#column-middle .box-content table .form-desc').each(function() {
		var thisObj = $(this);
		thisObj.html('E-postadress');
		
		var emailContainer = thisObj.next();
		var email = emailContainer.find('a').html();
		
		emailContainer.html('<a href="mailto:'+email+'">'+email+'</a>');
		
  });
  
  $('#column-middle .box-content table td img').removeAttr('alt');
  
});
